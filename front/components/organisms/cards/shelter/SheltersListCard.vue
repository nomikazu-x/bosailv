<template>
  <div class="mt-4">
    <TheProcessing v-if="processing" />
    <BaseTitleCard :title="info.city_name + '付近の避難所一覧'">
      <v-card v-if="shelters != null && shelters.length === 0" outlined tile>
        <v-card-title class="ml-1">該当する避難所はありません。</v-card-title>
      </v-card>
      <v-col v-else cols="12">
        <v-card-title v-if="info">検索結果：{{ info.total_count }}件</v-card-title>
      </v-col>
      <div v-for="shelter in shelters" :key="shelter.id">
        <ShelterListCardText
          :shelter="shelter"
        />
      </div>

      <ThePagination
        class="mt-5"
        :info="info"
        @pagination="onPagination"
      />
    </BaseTitleCard>
  </div>
</template>

<script>
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import ShelterListCardText from '~/components/organisms/cardText/ShelterListCardText.vue'
import ThePagination from '~/components/organisms/pagination/ThePagination.vue'

export default {
  name: 'SheltersListCard',

  components: {
    TheProcessing,
    BaseTitleCard,
    ShelterListCardText,
    ThePagination
  },

  props: {
    info: {
      type: Object,
      default: null
    },

    shelters: {
      type: Array,
      default: () => []
    },

    processing: {
      type: Boolean,
      default: false
    }
  },

  methods: {
    onPagination (value) {
      return this.$emit('pagination', value)
    }
  }
}
</script>
