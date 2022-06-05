<template>
  <v-row>
    <v-col cols="11" class="pa-0">
      <v-list-item :to="getTo">
        <v-list-item-icon>
          <v-icon>mdi-file</v-icon>
        </v-list-item-icon>

        <v-list-item-content>
          <v-list-item-title>
            {{ title }}
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-col>

    <v-col v-if="canAction" cols="1" class="pa-0 d-flex justify-center align-center">
      <v-menu bottom left>
        <template #activator="{ on, attrs }">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
          >
            <v-icon>mdi-dots-vertical</v-icon>
          </v-btn>
        </template>

        <v-list>
          <v-list-item @click="onChangeName">
            <v-list-item-title>編集する</v-list-item-title>
          </v-list-item>

          <v-list-item @click="onDelete">
            <v-list-item-title>削除する</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-col>
  </v-row>
</template>

<script>
export default {
  props: {
    canAction: {
      type: Boolean,
      default: false
    },
    id: {
      type: [String, Number],
      required: true
    },
    title: {
      type: String,
      required: true
    },
    to: {
      type: [String, Object],
      default: undefined
    }
  },
  computed: {
    getTo () {
      return !this.isChangingName ? this.to : undefined
    }
  },
  methods: {
    onDelete () {
      return this.$emit('delete', {
        id: this.id
      })
    }
  }
}
</script>
