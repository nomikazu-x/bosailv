<template>
  <div v-if="infomations != null && infomations.length > 0">
    <v-card v-if="infomations != null && infomations.length > 0">
      <v-card-title>大切なお知らせ</v-card-title>
      <v-card-text>
        <article v-for="infomation in infomations" :key="infomation.id" class="mb-1">
          <InfomationLabel :infomation="infomation" />
          <span class="ml-1">
            <template v-if="infomation.body_present === true || infomation.summary !== null">
              <NuxtLink :to="{ name: 'infomations-id___ja', params: { id: infomation.id }}">{{ infomation.title }}</NuxtLink>
            </template>
            <template v-else>
              {{ infomation.title }}
            </template>
          </span>
          <span class="ml-1">
            ({{ $dateFormat(infomation.started_at, 'ja') }})
          </span>
        </article>
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
