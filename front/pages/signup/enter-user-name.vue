<script>
export default {
  asyncData({redirect}) {
    return redirect('/signin', {
      type: 'new'
    })
  }
}
</script>
