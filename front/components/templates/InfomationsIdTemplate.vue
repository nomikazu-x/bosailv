<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="8"
    :right-cols="12"
    :right-sm="4"
  >
    <template #top>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template #left>
      <v-row v-if="!loading" justify="center">
        <v-col cols="12">
          <BaseTitleCard v-if="!loading" title="お知らせ">
            <div class="pa-3">
              <v-card-title v-if="infomation">
                <InfomationLabel :infomation="infomation" />
                <span class="ml-1 font-weight-bold">
                  {{ infomation.title }}
                </span>
                <span class="ml-1">
                  <v-icon>mdi-calendar-range</v-icon>
                  {{ $dateFormat(infomation.started_at, 'ja') }}
                </span>
              </v-card-title>
              <v-card-text v-if="infomation">
                <!-- eslint-disable-next-line vue/no-v-html -->
                <div v-if="infomation.body" class="mx-2 my-2" v-html="infomation.body" />
                <!-- eslint-disable-next-line vue/no-v-html -->
                <div v-else-if="infomation.summary" class="mx-2 my-2" v-html="infomation.summary" />
              </v-card-text>
              <v-divider />
              <v-card-actions>
                <NuxtLink to="/infomations" class="ml-2 text-decoration-none">一覧へ</NuxtLink>
              </v-card-actions>
            </div>
          </BaseTitleCard>
        </v-col>
      </v-row>
    </template>

    <template #right>
      <DefaultRightColumnTemplate :loading="loading" />
    </template>
  </TwoColumnContainer>
</template>

<script>
export default {
  props: {
    infomation: {
      type: Object,
      default: null
    },
    loading: {
      type: Boolean,
      default: false
    },
    alert: {
      type: String,
      default: null
    },
    notice: {
      type: String,
      default: null
    }
  }
}
</script>
