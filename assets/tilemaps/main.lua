return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.12.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 10,
  height = 9,
  tilewidth = 16,
  tileheight = 16,
  nextlayerid = 2,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "dungeon practice 5-Sheet-Sheet",
      firstgid = 1,
      class = "",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      columns = 5,
      image = "tiles.png",
      imagewidth = 80,
      imageheight = 80,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      wangsets = {},
      tilecount = 25,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 10,
      height = 9,
      id = 1,
      name = "Tile Layer 1",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        21, 6, 6, 6, 6, 23, 0, 0, 0, 0,
        20, 10, 11, 11, 11, 24, 0, 0, 0, 0,
        20, 9, 14, 14, 7, 6, 6, 0, 0, 0,
        20, 9, 7, 12, 3, 11, 11, 0, 0, 0,
        0, 22, 7, 3, 3, 3, 7, 0, 0, 0,
        0, 0, 7, 7, 7, 22, 22, 0, 0, 0,
        0, 0, 22, 22, 12, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 22, 0, 0, 0, 0, 0
      }
    }
  }
}
