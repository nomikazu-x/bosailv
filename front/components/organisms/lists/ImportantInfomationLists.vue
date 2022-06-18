<template>
  <div v-if="infomations != null && infomations.length > 0">
    <v-card v-if="infomations != null && infomations.length > 0">
      <v-card-title>大切なお知らせ</v-card-title>
      <v-card-text>
        <v-list v-for="infomation in infomations" :key="infomation.id" class="mb-1">
          <v-divider class="mb-4" />
          <InfomationLabel :infomation="infomation" />
          <div v-if="infomation.body_present === true || infomation.summary !== null">
            <v-list-item :to="{ name: 'infomations-id___ja', params: { id: infomation.id }}">
              <v-list-item-title>{{ infomation.title }}</v-list-item-title>
              <span>
                ({{ $dateFormat(infomation.started_at, 'ja') }})
              </span>
            </v-list-item>
          </div>
          <div v-else>
            <v-list-item>
              <v-list-item-title>
                {{ infomation.title }}
              </v-list-item-title>
              <span>
                ({{ $dateFormat(infomation.started_at, 'ja') }})
              </span>
            </v-list-item>
          </div>
        </v-list>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
export default {
  name: 'IndexInfomations',
  props: {
    infomations: {
      type: Array,
      default: () => []
    }
  }
}
</script>
