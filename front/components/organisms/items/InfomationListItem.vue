<template>
  <v-list>
    <InfomationLabel v-if="infomation != null && infomation.label !== 'Not'" :infomation="infomation" class="ml-1" />
    <div v-if="infomation.article_id_present === true">
      <BaseListItem dense :to="{ name: 'articles-id___ja', params: { id: infomation.article_id }}">
        <v-list-item-icon>
          <v-icon>mdi-bell</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title class="wrap-text">
            {{ infomation.title }}
          </v-list-item-title>
          <v-list-item-subtitle class="text-right">
            <v-icon small>mdi-calendar-range</v-icon>
            {{ $dateFormat(infomation.started_at, 'ja') }}
          </v-list-item-subtitle>
        </v-list-item-content>
      </BaseListItem>
    </div>
    <div v-else>
      <div v-if="infomation.body_present === true">
        <BaseListItem dense :to="{ name: 'infomations-id___ja', params: { id: infomation.id }}">
          <v-list-item-icon>
            <v-icon>mdi-bell</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title class="wrap-text">
              {{ infomation.title }}
            </v-list-item-title>
            <v-list-item-subtitle class="text-right">
              <v-icon small>mdi-calendar-range</v-icon>
              {{ $dateFormat(infomation.started_at, 'ja') }}
            </v-list-item-subtitle>
          </v-list-item-content>
        </BaseListItem>
      </div>
      <div v-else>
        <v-list-item dense>
          <v-list-item-icon>
            <v-icon>mdi-bell</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title class="wrap-text">
              {{ infomation.title }}
            </v-list-item-title>
            <v-list-item-subtitle class="text-right">
              <v-icon small>mdi-calendar-range</v-icon>
              {{ $dateFormat(infomation.started_at, 'ja') }}
            </v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
      </div>
    </div>
    <v-divider />
  </v-list>
</template>

<script>
import InfomationLabel from '~/components/atoms/label/InfomationLabel.vue'
import BaseListItem from '~/components/molecules/items/BaseListItem.vue'

export default {
  name: 'InfomationListItem',

  components: {
    InfomationLabel,
    BaseListItem
  },

  props: {
    infomation: {
      type: Object,
      default: null
    }
  }
}
</script>

<style lang="scss" scoped>
.wrap-text {
  word-break: break-all;
  white-space: normal;
}
</style>
