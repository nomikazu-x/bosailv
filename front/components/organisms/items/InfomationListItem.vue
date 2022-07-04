<template>
  <v-list>
    <InfomationLabel v-if="infomation != null && infomation.label !== 'Not'" :infomation="infomation" class="ml-1" />
    <div v-if="infomation.article_id_present === true">
      <BaseListItem dense :to="{ name: 'articles-id___ja', params: { id: infomation.article_id }}">
        <v-icon class="mr-4">mdi-account-heart</v-icon>
        <v-list-item-title>{{ infomation.title }}</v-list-item-title>
        <span>
          ({{ $dateFormat(infomation.started_at, 'ja') }})
        </span>
      </BaseListItem>
    </div>
    <div v-else>
      <div v-if="infomation.body_present === true">
        <BaseListItem dense :to="{ name: 'infomations-id___ja', params: { id: infomation.id }}">
          <v-icon class="mr-4">mdi-bell</v-icon>
          <v-list-item-title>{{ infomation.title }}</v-list-item-title>
          <span>
            ({{ $dateFormat(infomation.started_at, 'ja') }})
          </span>
        </BaseListItem>
      </div>
      <div v-else>
        <v-list-item dense>
          <v-icon class="mr-4">mdi-bell</v-icon>
          <v-list-item-title>
            {{ infomation.title }}
          </v-list-item-title>
          <span>
            ({{ $dateFormat(infomation.started_at, 'ja') }})
          </span>
        </v-list-item>
      </div>
    </div>
    <v-divider />
  </v-list>
</template>

<script>
export default {
  name: 'InfomationListItem',
  props: {
    infomation: {
      type: Object,
      default: null
    }
  }
}
</script>
