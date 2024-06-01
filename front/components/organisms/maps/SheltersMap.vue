<template>
  <v-card v-if="shelters.length > 0" outlined tile class="mt-4 py-2">
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
  </v-card>
</template>

<script>
export default {
  name: 'SheltersMap',

  props: {
    shelters: {
      type: Array,
      default: () => []
    }
  },

  data () {
    return {
      selectedShelter: {},
      infoWindowPos: null,
      infoWinOpen: false,
      currentMidx: null,
      infoOptions: {
        minWidth: 200,
        pixelOffset: {
          width: 0,
          height: -35
        }
      }
    }
  },

  computed: {
    shelterInfo () {
      if (this.selectedShelter !== null) {
        return [
          { id: 1, type: '洪水', is_selected: this.selectedShelter.flood, icon: 'mdi-home-flood' },
          { id: 2, type: '土砂災害', is_selected: this.selectedShelter.landslide, icon: 'mdi-landslide' },
          { id: 3, type: '高潮', is_selected: this.selectedShelter.storm_surge, icon: 'mdi-tsunami' },
          { id: 4, type: '地震', is_selected: this.selectedShelter.earthquake, icon: 'mdi-image-broken-variant' },
          { id: 5, type: '津波', is_selected: this.selectedShelter.tsunami, icon: 'mdi-tsunami' },
          { id: 6, type: '火事', is_selected: this.selectedShelter.fire, icon: 'mdi-fire' },
          { id: 7, type: '内水氾濫', is_selected: this.selectedShelter.inland_flood, icon: 'mdi-home-flood' },
          { id: 8, type: '火山噴火', is_selected: this.selectedShelter.volcano, icon: 'mdi-volcano' }
        ]
      } else {
        return null
      }
    }
  },

  methods: {
    toggleInfoWindow (shelter, idx) {
      this.infoWindowPos = { lat: parseFloat(shelter.latitude), lng: parseFloat(shelter.longitude) }
      this.selectedShelter = shelter
      if (this.currentMidx === idx) {
        this.infoWinOpen = !this.infoWinOpen
      } else {
        this.infoWinOpen = true
        this.currentMidx = idx
      }
    },

    centerInfo (shelters) {
      return { lat: parseFloat(shelters[0].latitude), lng: parseFloat(shelters[0].longitude) }
    }
  }
}
</script>
