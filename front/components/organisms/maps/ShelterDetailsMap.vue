<template>
  <GmapMap
    v-if="shelter !== null"
    map-type-id="roadmap"
    :center="{ lat: parseFloat(shelter.latitude), lng: parseFloat(shelter.longitude) }"
    :zoom="17"
    :options="{
      zoomControl: true,
      mapTypeControl: false,
      scaleControl: false,
      streetViewControl: false,
      rotateControl: false,
      fullscreenControl: true,
    }"
    style="width: 100%; height: 350px; margin: auto"
  >
    <GmapMarker
      :position="{ lat: parseFloat(shelter.latitude), lng: parseFloat(shelter.longitude) }"
      :clickable="false"
    />
  </GmapMap>
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
