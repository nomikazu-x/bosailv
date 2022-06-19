<template>
  <v-list>
    <InfomationLabel v-if="infomation != null && infomation.label !== 'Not'" :infomation="infomation" class="ml-1" />
    <div v-if="infomation.article_id_present === true">
      <BaseList :to="{ name: 'articles-id___ja', params: { id: infomation.article_id }}">
        <v-icon class="mr-4">mdi-account-heart</v-icon>
        <v-list-item-title>{{ infomation.title }}</v-list-item-title>
        <span>
          ({{ $dateFormat(infomation.started_at, 'ja') }})
        </span>
      </BaseList>
    </div>
    <div v-else>
      <div v-if="infomation.body_present === true">
        <BaseList :to="{ name: 'infomations-id___ja', params: { id: infomation.id }}">
          <v-icon class="mr-4">mdi-bell</v-icon>
          <v-list-item-title>{{ infomation.title }}</v-list-item-title>
          <span>
            ({{ $dateFormat(infomation.started_at, 'ja') }})
          </span>
        </BaseList>
      </div>
      <div v-else>
        <v-list-item>
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
  props: {
    infomation: {
      type: Object,
      default: null
    }
  }
}
</script>
