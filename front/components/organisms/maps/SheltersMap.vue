<template>
  <GmapMap
    ref="gmap"
    map-type-id="roadmap"
    :center="center"
    :zoom="15"
    :options="{
      zoomControl: true,
      mapTypeControl: false,
      scaleControl: false,
      streetViewControl: false,
      rotateControl: false,
      fullscreenControl: true,
    }"
    style="width: 500px; height: 300px; margin: auto"
  >
    <GmapMarker
      v-for="(m, i) in markers"
      :key="i"
      :position="m.position"
      :clickable="true"
      @click="toggleInfoWindow(m,i)"
    />
    <GmapInfoWindow
      :options="infoOptions"
      :position="infoWindowPos"
      :opened="infoWinOpen"
      @closeClick="infoWinOpen = false"
    >
      <div>{{ selectMarkerText }}</div>
    </GmapInfoWindow>
  </GmapMap>
</template>

<script>
export default {
  name: 'SheltersMap',

  data () {
    return {
      center: { lat: 34.7054595, lng: 137.6852776 },
      infoWindowPos: null,
      infoWinOpen: false,
      currentMidx: null,
      selectMarkerText: '',
      infoOptions: {
        minWidth: 200,
        pixelOffset: {
          width: 0,
          height: -35
        }
      },
      markers: [
        {
          title: '佐鳴湖',
          position: { lat: 34.7054595, lng: 137.6852776 }
        },
        {
          title: '浜名湖ガーデンパーク',
          position: { lat: 34.7140247, lng: 137.6032967 }
        }
      ]
    }
  },
  methods: {
    toggleInfoWindow (marker, idx) {
      this.infoWindowPos = marker.position
      this.selectMarkerText = marker.title
      if (this.currentMidx === idx) {
        this.infoWinOpen = !this.infoWinOpen
      } else {
        this.infoWinOpen = true
        this.currentMidx = idx
      }
    }
  }
}
</script>
