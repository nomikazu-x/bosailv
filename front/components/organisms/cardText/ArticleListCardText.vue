<template>
  <BaseCard :to="{ name: 'articles-id___ja', params: { id: article.id }}" class="my-2">
    <v-card-text class="black--text">
      <v-row>
        <v-col cols="4" align="center">
          <v-img :src="article.thumbnail_url.large" max-height="128" max-width="192" class="ml-5 mt-2 rounded-lg" />
        </v-col>
        <v-col cols="8">
          <v-card-title class="font-weight-bold">
            {{ article.title }}
          </v-card-title>
          <v-card-text class="mt-10 text-right">
            <v-icon small>mdi-calendar-range</v-icon>
            {{ $dateFormat(article.created_at, 'ja') }}
          </v-card-text>
        </v-col>
      </v-row>
    </v-card-text>
  </BaseCard>
</template>

<script>
import BaseCard from '~/components/molecules/cards/BaseCard.vue'

export default {
  name: 'ArticleListCardText',

  components: {
    BaseCard
  },

  props: {
    article: {
      type: Object,
      default: null
    }
  }
}
</script>
