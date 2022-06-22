<template>
  <v-card>
    <v-img :src="article.thumbnail_url.xlarge" max-height="256" />
    <v-col>
      <v-card-subtitle>
        <span>
          掲載日：{{ $dateFormat(article.created_at, 'ja') }}
        </span>
        <span class="ml-2">
          更新日：{{ $dateFormat(article.updated_at, 'ja') }}
        </span><br>
        <span class="mt-1">
          <v-icon small>mdi-pencil</v-icon>
          <v-avatar size="20" class="mr-1">
            <v-img :src="article.user.image_url.small" />
          </v-avatar>
          <NuxtLink :to="{ name: 'users-username___ja', params: { username: article.user.username }}" class="text-decoration-none">{{ article.user.name }}</NuxtLink>
        </span>
        <v-row justify="center" class="mt-3">
          <v-btn large color="#00AEEF" outlined icon><v-icon size="30" color="#00AEEF">mdi-twitter</v-icon></v-btn>
          <v-btn class="ml-5" large color="#3b5998" outlined icon><v-icon size="30" color="#3b5998">mdi-facebook</v-icon></v-btn>
        </v-row>
      </v-card-subtitle>
    </v-col>
    <v-col cols="12">
      <v-card-title class="font-weight-bold">
        {{ article.title }}
      </v-card-title>

      <div class="text-right">
        <FavoriteBtnGroup class="mr-3 mt-2" :article="article" :alert="alert" :notice="notice" />
        <v-menu bottom right>
          <template #activator="{ on, attrs }">
            <v-btn
              icon
              outlined
              v-bind="attrs"
              v-on="on"
            >
              <v-icon>mdi-pencil</v-icon>
            </v-btn>
          </template>

          <v-list>
            <v-list-item :to="`/articles/${$route.params.id}/edit`">
              <v-list-item-title>編集する</v-list-item-title>
            </v-list-item>

            <v-list-item @click="onArticleDelete(article.id)">
              <v-list-item-title>削除する</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
      </div>
      <v-divider class="my-5" />
      <v-card-text v-if="article">
        <!-- eslint-disable-next-line vue/no-v-html -->
        <div v-if="article.content" class="mx-2 my-2" v-html="article.content" />
      </v-card-text>
    </v-col>
  </v-card>
</template>

<script>
export default {
  props: {
    article: {
      type: Object,
      default: null
    },
    alert: {
      type: String,
      default: null
    },
    notice: {
      type: String,
      default: null
    }
  },
  data () {
    return {
      menu: false
    }
  },
  methods: {
    onArticleDelete (articleId) {
      this.$emit('article-delete', articleId)
    }
  }
}
</script>
