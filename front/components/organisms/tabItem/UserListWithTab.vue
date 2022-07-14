<template>
  <div>
    <TheProcessing v-if="processing" />
    <v-card tile>
      <v-card v-if="users != null && users.length === 0">
        <v-card-title class="ml-1">ユーザーはいません。</v-card-title>
        <v-divider class="my-4" />
      </v-card>
      <UserListItem
        v-for="(user, i) in users"
        :key="user.id"
        :user="user"
        :index="i"
      />

      <ThePagination
        class="mt-5"
        :info="info"
        @pagination="onPagination"
      />
    </v-card>
  </div>
</template>

<script>
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import UserListItem from '~/components/organisms/items/UserListItem.vue'
import ThePagination from '~/components/organisms/pagination/ThePagination.vue'

export default {
  name: 'UserListCardWithTab',

  components: {
    TheProcessing,
    UserListItem,
    ThePagination
  },

  props: {
    users: {
      type: Array,
      default: () => []
    },
    info: {
      type: Object,
      default: null
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
