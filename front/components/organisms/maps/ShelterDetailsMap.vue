<template>
  <iframe
    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3241.747798841979!2d139.74285797634224!3d35.65858483121676!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x60188bbd9009ec09%3A0x481a93f0d2a409dd!2z5p2x5Lqs44K_44Ov44O8!5e0!3m2!1sja!2sjp!4v1708950259061!5m2!1sja!2sjp"
    width="100%"
    height="350"
    style="border:0;"
    allowfullscreen=""
    loading="lazy"
    referrerpolicy="no-referrer-when-downgrade"
  >
  </iframe>
</template>

<script>
export default {
  name: 'ShelterDetailMap',

  props: {
    shelter: {
      type: Object,
      default: null
    }
  }
}
</script>
