####################################################
# CodePipeLine - CodeStarConnection
####################################################

resource "aws_codestarconnections_connection" "github" {
  name = "${local.app_name}-github-connection"
  provider_type = "GitHub"
}

####################################################
# CodePipeLine - IAM Role
####################################################

resource "aws_iam_role" "codepipeline_role" {
  name = "${local.app_name}-codepipeline-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "pipeline_service" {
  policy = file("./json/code_pipeline/AWSCodePipelineServiceRole.json")
}

resource "aws_iam_role_policy_attachment" "attache_pipeline_service" {
  policy_arn = aws_iam_policy.pipeline_service.arn
  role       = aws_iam_role.codepipeline_role.name
}

####################################################
# CodePipeLine - S3 Artifact Store
####################################################

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${local.app_name}-codepipeline"
  acl = "private"
  force_destroy = false
}

####################################################
# CodePipeLine - CodeBuild project
####################################################

locals {
  aws_ecr_codebuild_image_url = "${var.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/bosailv-codebuild"
  IAM_POLICY_ARN_KMSReadOnly = "arn:aws:iam::${var.account_id}:policy/KMSReadOnly"
  IAM_POLICY_ARN_AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  IMA_POLICY_ARN_AmazonSSMReadOnlyAccess = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role" "build_role" {
  name = "${local.app_name}-codebuild-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "build_base" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": ["*"],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ],
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:CreateReportGroup",
        "codebuild:CreateReport",
        "codebuild:UpdateReport",
        "codebuild:BatchPutTestCases",
        "codebuild:BatchPutCodeCoverages"
      ],
      "Resource": [
        "arn:aws:codebuild:ap-northeast-1:${var.account_id}:report-group/*"
      ]
    }
  ]
}
EOF
  name = "${local.app_name}-CodeBuildBasePolicy"
}

resource "aws_iam_policy" "build_secret" {
  policy = templatefile(
    "./json/code_build/CodeBuildManagedSecretPolicy.json",
    { account_id = "${var.account_id}" }
  )
}

resource "aws_iam_policy" "build_vpc" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": "arn:aws:ec2:ap-northeast-1:${var.account_id}:network-interface/*",
      "Condition": {
        "StringEquals": {
          "ec2:Subnet": [
            "${aws_subnet.private_1a.arn}"
          ],
          "ec2:AuthorizedService": "codebuild.amazonaws.com"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "build_ecr_put" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:BatchGetImage",
                "ecr:CompleteLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "build_base_attach" {
  policy_arn = aws_iam_policy.build_base.arn
  role       = aws_iam_role.build_role.name
}
resource "aws_iam_role_policy_attachment" "build_secret_attach" {
  policy_arn = aws_iam_policy.build_secret.arn
  role       = aws_iam_role.build_role.name
}

resource "aws_iam_role_policy_attachment" "build_vpc_attach" {
  policy_arn = aws_iam_policy.build_vpc.arn
  role       = aws_iam_role.build_role.name
}
resource "aws_iam_role_policy_attachment" "build_kms_read" {
  policy_arn = local.IAM_POLICY_ARN_KMSReadOnly
  role       = aws_iam_role.build_role.name
}
resource "aws_iam_role_policy_attachment" "build_ecr_read" {
  policy_arn = local.IAM_POLICY_ARN_AmazonEC2ContainerRegistryReadOnly
  role       = aws_iam_role.build_role.name
}
resource "aws_iam_role_policy_attachment" "build_ecr_put" {
  policy_arn = aws_iam_policy.build_ecr_put.arn
  role       = aws_iam_role.build_role.name
}
resource "aws_iam_role_policy_attachment" "build_ssm_read" {
  policy_arn = local.IMA_POLICY_ARN_AmazonSSMReadOnlyAccess
  role       = aws_iam_role.build_role.name
}
resource "aws_codebuild_project" "build" {
  name         = "${local.app_name}-buildproject"
  service_role = aws_iam_role.build_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = local.aws_ecr_codebuild_image_url
    type         = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "DB_HOST"
      value = aws_ssm_parameter.database_url.name
      type = "PARAMETER_STORE"
    }
    environment_variable {
      name  = "DB_DATABASE"
      value = data.aws_ssm_parameter.database_name.name
      type = "PARAMETER_STORE"
    }
    environment_variable {
      name  = "DB_USERNAME"
      value = data.aws_ssm_parameter.database_user.name
      type = "PARAMETER_STORE"
    }
    environment_variable {
      name  = "DB_PASSWORD"
      value = data.aws_ssm_parameter.database_password.name
      type = "PARAMETER_STORE"
    }
    environment_variable {
      name  = "APP_KEY"
      value = data.aws_ssm_parameter.app_key.name
      type = "PARAMETER_STORE"
    }
    environment_variable {
      name  = "APP_ENV"
      value = local.app_env_codebuild
    }
    environment_variable {
      name  = "APP_DEBUG"
      value = local.app_debug_codebuild
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.account_id
    }
  }
  vpc_config {
    security_group_ids = [
      aws_security_group.app.id
    ]
    subnets            = [
      aws_subnet.private_1a.id
    ]
    vpc_id             = aws_vpc.this.id
  }
  source {
    type = "CODEPIPELINE"
  }
}
####################################################
# CodePipeLine - Pipeline
####################################################

resource "aws_codepipeline" "pipeline" {
  name     = "${local.app_name}-pipeline-deploy"
  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      category = "Source"
      name     = "Source"
      owner    = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = 1
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "kazuki-ayimon/bosailv"
        BranchName           = "master"
      }
    }
  }

  stage {
    name = "Build"
    action {
      category = "Build"
      name     = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["source_output"]
      output_artifacts = ["build_output"]
      version  = "1"
      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      category = "Deploy"
      name     = "frontend-deploy"
      owner    = "AWS"
      provider = "ECS"
      version  = "1"
      input_artifacts = ["build_output"]
      configuration = {
        FileName = "frontend_imagedefinitions.json"
        ClusterName = aws_ecs_cluster.this.name
        ServiceName = aws_ecs_service.frontend.name
      }
    }
    action {
      category = "Deploy"
      name     = "backend-deploy"
      owner    = "AWS"
      provider = "ECS"
      version  = "1"
      input_artifacts = ["build_output"]
      configuration = {
        FileName = "backend_imagedefinitions.json"
        ClusterName = aws_ecs_cluster.this.name
        ServiceName = aws_ecs_service.backend.name
      }
    }
  }
}
