<template>
  <BaseCard :to="{ name: 'articles-id___ja', params: { id: article.id }}">
    <v-card-text class="black--text">
      <v-row align="center" no-gutters>
        <v-col cols="4">
          <v-img :src="article.thumbnail_url.large" max-height="128" max-width="192" class="rounded-lg" />
        </v-col>
        <v-col cols="8">
          <v-card-title>
            {{ article.title }}
          </v-card-title>
          <div class="mt-7 text-right">
            <v-icon small>mdi-calendar-range</v-icon>
            {{ $dateFormat(article.created_at, 'ja') }}
          </div>
        </v-col>
      </v-row>
    </v-card-text>
    <v-divider />
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
