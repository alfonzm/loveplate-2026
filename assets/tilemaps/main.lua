return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.12.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 20,
  height = 20,
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
      tiles = {
        {
          id = 0,
          properties = {
            ["collidable"] = false
          }
        },
        {
          id = 1,
          properties = {
            ["collidable"] = false
          }
        },
        {
          id = 2,
          properties = {
            ["collidable"] = false
          }
        },
        {
          id = 3,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 4,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 5,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 6,
          properties = {
            ["collidable"] = false
          }
        },
        {
          id = 7,
          properties = {
            ["collidable"] = false
          }
        },
        {
          id = 8,
          properties = {
            ["collidable"] = false
          }
        },
        {
          id = 9,
          properties = {
            ["collidable"] = false
          }
        },
        {
          id = 10,
          properties = {
            ["collidable"] = false
          }
        },
        {
          id = 11,
          properties = {
            ["collidable"] = false
          }
        },
        {
          id = 12,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 13,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 14,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 15,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 16,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 17,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 18,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 19,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 20,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 21,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 22,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 23,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 24,
          properties = {
            ["collidable"] = false
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
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
        21, 6, 6, 6, 6, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        20, 10, 11, 11, 11, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        20, 9, 14, 14, 7, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 6, 6, 23,
        20, 9, 7, 12, 3, 11, 11, 6, 6, 6, 6, 6, 18, 18, 18, 7, 7, 7, 7, 24,
        0, 22, 7, 3, 3, 3, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 24,
        0, 0, 7, 7, 7, 7, 7, 7, 14, 7, 7, 7, 5, 5, 5, 7, 7, 7, 7, 24,
        0, 0, 22, 22, 12, 22, 22, 7, 7, 7, 7, 7, 0, 0, 0, 7, 7, 7, 7, 24,
        0, 0, 0, 12, 8, 8, 0, 7, 7, 7, 7, 7, 0, 0, 0, 13, 13, 7, 13, 24,
        0, 0, 0, 22, 22, 22, 0, 22, 22, 22, 22, 22, 0, 0, 0, 0, 0, 7, 0, 24,
        0, 0, 0, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 24,
        0, 0, 0, 0, 0, 11, 11, 0, 6, 6, 6, 6, 6, 6, 0, 7, 7, 7, 7, 24,
        0, 0, 0, 0, 0, 7, 7, 0, 11, 11, 11, 11, 11, 11, 7, 7, 7, 7, 7, 24,
        0, 0, 21, 6, 6, 7, 7, 7, 7, 7, 7, 8, 3, 7, 0, 7, 7, 7, 7, 24,
        0, 0, 20, 10, 11, 7, 7, 7, 7, 7, 7, 8, 3, 7, 0, 13, 13, 13, 13, 24,
        0, 0, 20, 9, 8, 7, 7, 7, 7, 7, 12, 7, 7, 7, 0, 0, 0, 0, 0, 0,
        0, 0, 20, 9, 8, 7, 3, 3, 7, 7, 7, 7, 7, 7, 0, 0, 0, 0, 0, 0,
        0, 0, 20, 9, 7, 7, 7, 7, 12, 7, 7, 7, 7, 7, 0, 0, 0, 0, 0, 0,
        0, 0, 20, 9, 7, 7, 12, 7, 7, 7, 8, 8, 7, 7, 0, 0, 0, 0, 0, 0,
        0, 0, 20, 9, 7, 7, 7, 7, 7, 7, 8, 3, 3, 7, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
