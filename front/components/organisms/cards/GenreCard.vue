<template>
  <v-card>
    <Processing v-if="processing" />
    <v-row>
      <v-col cols="12">
        <v-card-title>困ったときは</v-card-title>
        <div v-for="genre in genres" :key="genre.id">
          <v-img :src="genre.image_url.xlarge" max-height="150" gradient="to top right, rgba(100,115,201,.33), rgba(25,32,72,.3)">
            <v-card-title class="genre-name mt-8 white--text justify-center align-center text-shadow">{{ genre.name }}</v-card-title>
          </v-img>
          <div v-for="article in genre.articles" :key="article.id">
            <ArticleListCard
              :article="article"
            />
          </div>
          <v-btn
            large
            class="my-5"
            color="green darken-3"
            outlined
            block
            :to="{ name: 'genres-id___ja', params: { id: genre.id }}"
          >
            {{ genre.name }}をもっと見る
          </v-btn>
        </div>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
export default {
  props: {
    genres: {
      type: Array,
      default: () => []
    },
    processing: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style lang="scss" scoped>
.genre-name {
  text-shadow: 1px 1px 0 #000, -1px 1px 0 #000, 1px -1px 0 #000, -1px -1px 0 #000;
}
</style>
