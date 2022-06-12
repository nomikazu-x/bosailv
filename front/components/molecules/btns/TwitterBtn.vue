<template>
  <v-btn
    color="#00AEEF"
    class="white--text"
    :dark="dark"
    :depressed="depressed"
    :fab="fab"
    :href="href"
    :target="vTarget"
    :rel="rel"
    :to="to"
    :x-small="xSmall"
    @click="onClick"
  >
    <TwitterIcon />
    <slot />
  </v-btn>
</template>

<script>
export default {
  props: {
    dark: {
      type: Boolean,
      default: false
    },
    depressed: {
      type: Boolean,
      default: false
    },
    fab: {
      type: Boolean,
      default: false
    },
    href: {
      type: String,
      default: undefined
    },
    target: {
      type: String,
      default: undefined
    },
    to: {
      type: [String, Object],
      default: undefined
    }
  },
  computed: {
    xSmall () {
      return this.fab
    },
    /**
     * targetがpropsで設定されていれば、それを返す
     * 設定されていなければ、hrefが設定されているときに、_blankを返す
     */
    vTarget () {
      if (this.target) {
        return this.target
      }
      return this.href ? '_blank' : undefined
    },
    rel () {
      return this.vTarget ? 'noopener' : undefined
    }
  },
  methods: {
    onClick () {
      return this.$emit('click')
    }
  }
}
</script>
