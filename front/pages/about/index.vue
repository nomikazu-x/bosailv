<template>
  <OneColumnContainer>
    <AboutIndexCard />
  </OneColumnContainer>
</template>

<script>
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import AboutIndexCard from '~/components/organisms/cards/AboutIndexCard.vue'

export default {
  components: {
    OneColumnContainer,
    AboutIndexCard
  }
}
</script>
