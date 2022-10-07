resource "aws_ecr_repository" "bosailv-frontend" {
  name = "${local.app_name}-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "bosailv-backend-nginx" {
  name = "${local.app_name}-backend-nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "bosailv-backend-rails" {
  name = "${local.app_name}-backend-rails"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "bosailv-codebuild" {
  name = "${local.app_name}-codebuild"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}