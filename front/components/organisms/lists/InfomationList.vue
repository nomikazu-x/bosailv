<template>
  <v-list>
    <v-divider class="mb-4" />
    <InfomationLabel :infomation="infomation" />
    <div v-if="infomation.article_id_present === true">
      <v-list-item :to="{ name: 'articles-id___ja', params: { id: infomation.article_id }}">
        <v-icon class="mr-4">mdi-account-heart</v-icon>
        <v-list-item-title>{{ infomation.title }}</v-list-item-title>
        <span>
          ({{ $dateFormat(infomation.started_at, 'ja') }})
        </span>
      </v-list-item>
    </div>
    <div v-else>
      <div v-if="infomation.body_present === true">
        <v-list-item :to="{ name: 'infomations-id___ja', params: { id: infomation.id }}">
          <v-icon class="mr-4">mdi-bell</v-icon>
          <v-list-item-title>{{ infomation.title }}</v-list-item-title>
          <span>
            ({{ $dateFormat(infomation.started_at, 'ja') }})
          </span>
        </v-list-item>
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
