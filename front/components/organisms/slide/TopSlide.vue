<template>
  <v-sheet style="background-color: #f9f5eb;">
    <v-slide-group
      multiple
      show-arrows
      center-active
    >
      <v-slide-item
        v-for="article in articles.slice(0, 5)"
        :key="article.id"
        class="text-center"
      >
        <v-card :to="{ name: 'articles-id___ja', params: { id: article.id }}" class="ma-1" style="width: 500px; height: 300px;">
          <v-img :src="article.thumbnail_url.xxlarge" class="white--text align-end" gradient="to bottom, rgba(0,0,0,.0), rgba(0,0,0,.5)" height="300px">
            <v-card-title v-text="article.title" />
          </v-img>
        </v-card>
      </v-slide-item>
    </v-slide-group>
  </v-sheet>
</template>

<script>
export default {
  props: {
    articles: {
      type: Array,
      default: () => []
    }
  }
}
</script>
