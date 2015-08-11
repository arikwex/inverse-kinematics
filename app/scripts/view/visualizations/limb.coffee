module.exports = {
  render: (self, gfx, limb) ->
    for segment in limb.segments
      self.render(gfx, segment)
    return
}