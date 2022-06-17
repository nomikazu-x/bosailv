<template>
  <v-list>
    <v-divider class="mb-4" />
    <InfomationLabel :list="list" />
    <div v-if="list.article_id_present === true">
      <v-list-item :to="{ name: 'articles-id___ja', params: { id: list.article_id }}">
        <v-icon class="mr-4">mdi-account-heart</v-icon>
        <v-list-item-title>{{ list.title }}</v-list-item-title>
        <span>
          ({{ $dateFormat(list.started_at, 'ja') }})
        </span>
      </v-list-item>
    </div>
    <div v-else>
      <div v-if="list.body_present === true">
        <v-list-item :to="{ name: 'infomations-id___ja', params: { id: list.id }}">
          <v-icon class="mr-4">mdi-bell</v-icon>
          <v-list-item-title>{{ list.title }}</v-list-item-title>
          <!-- eslint-disable-next-line vue/no-v-html -->
          <v-list-item-subtitle v-if="list.summary" v-html="list.summary" />
          <span>
            ({{ $dateFormat(list.started_at, 'ja') }})
          </span>
        </v-list-item>
      </div>
      <div v-else>
        <v-list-item>
          <v-icon class="mr-4">mdi-bell</v-icon>
          <v-list-item-title>
            {{ list.title }}
          </v-list-item-title>
          <span>
            ({{ $dateFormat(list.started_at, 'ja') }})
          </span>
        </v-list-item>
      </div>
    </div>
  </v-list>
</template>

<script>
export default {
  props: {
    list: {
      type: Object,
      default: null
    }
  }
}
</script>
