return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.16.0",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 36,
  height = 36,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 11,
  properties = {},
  tilesets = {
    {
      name = "tileset",
      firstgid = 1,
      filename = "../../tileset.tsx",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "../../art/tileset.png",
      imagewidth = 320,
      imageheight = 320,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {
        {
          name = "Wall",
          tile = 0,
          properties = {}
        },
        {
          name = "Markings",
          tile = 40,
          properties = {}
        },
        {
          name = "Plain Wall",
          tile = 80,
          properties = {}
        }
      },
      tilecount = 400,
      tiles = {
        {
          id = 0,
          terrain = { -1, -1, -1, 0 }
        },
        {
          id = 1,
          terrain = { -1, -1, 0, -1 }
        },
        {
          id = 2,
          terrain = { -1, 0, 0, 0 }
        },
        {
          id = 3,
          terrain = { 0, -1, 0, 0 }
        },
        {
          id = 4,
          terrain = { -1, -1, 0, 0 }
        },
        {
          id = 5,
          terrain = { 0, -1, 0, -1 }
        },
        {
          id = 7,
          terrain = { 0, 0, 0, 0 }
        },
        {
          id = 8,
          terrain = { 0, 0, 0, 0 }
        },
        {
          id = 20,
          terrain = { -1, 0, -1, -1 }
        },
        {
          id = 21,
          terrain = { 0, -1, -1, -1 }
        },
        {
          id = 22,
          terrain = { 0, 0, -1, 0 }
        },
        {
          id = 23,
          terrain = { 0, 0, 0, -1 }
        },
        {
          id = 24,
          terrain = { -1, 0, -1, 0 }
        },
        {
          id = 25,
          terrain = { 0, 0, -1, -1 }
        },
        {
          id = 27,
          terrain = { 0, 0, 0, 0 }
        },
        {
          id = 28,
          terrain = { 0, 0, 0, 0 }
        },
        {
          id = 40,
          terrain = { 2, 2, 2, 1 }
        },
        {
          id = 41,
          terrain = { 2, 2, 1, 2 }
        },
        {
          id = 42,
          terrain = { 2, 2, 1, 1 }
        },
        {
          id = 43,
          terrain = { 1, 2, 1, 2 }
        },
        {
          id = 44,
          terrain = { 2, 1, 1, 1 }
        },
        {
          id = 45,
          terrain = { 1, 2, 1, 1 }
        },
        {
          id = 60,
          terrain = { 2, 1, 2, 2 }
        },
        {
          id = 61,
          terrain = { 1, 2, 2, 2 }
        },
        {
          id = 62,
          terrain = { 2, 1, 2, 1 }
        },
        {
          id = 63,
          terrain = { 1, 1, 2, 2 }
        },
        {
          id = 64,
          terrain = { 1, 1, 2, 1 }
        },
        {
          id = 65,
          terrain = { 1, 1, 1, 2 }
        },
        {
          id = 80,
          terrain = { 2, 2, 2, 2 }
        },
        {
          id = 81,
          terrain = { 1, 1, 1, 1 }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "background",
      x = 0,
      y = 0,
      width = 36,
      height = 36,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81,
        81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81
      }
    },
    {
      type = "tilelayer",
      name = "platforms",
      x = 0,
      y = 0,
      width = 36,
      height = 36,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "walls",
      x = 0,
      y = 0,
      width = 36,
      height = 36,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        29, 29, 29, 9, 9, 8, 28, 28, 9, 28, 28, 9, 28, 8, 9, 8, 9, 9, 8, 28, 8, 28, 9, 28, 9, 8, 8, 8, 29, 8, 28, 28, 9, 8, 28, 9,
        29, 29, 28, 28, 28, 9, 29, 8, 8, 8, 8, 28, 28, 29, 8, 28, 9, 29, 8, 8, 29, 8, 9, 28, 9, 9, 28, 28, 29, 8, 8, 9, 29, 8, 9, 8,
        28, 8, 28, 28, 28, 28, 29, 29, 9, 9, 29, 28, 28, 8, 29, 8, 9, 28, 8, 29, 29, 9, 9, 8, 8, 9, 8, 8, 29, 9, 29, 8, 28, 29, 29, 29,
        9, 28, 28, 9, 8, 28, 29, 28, 29, 8, 8, 9, 29, 29, 29, 9, 8, 9, 29, 9, 9, 8, 28, 8, 29, 28, 28, 29, 9, 28, 8, 8, 9, 28, 29, 29,
        8, 9, 9, 29, 9, 8, 8, 28, 8, 9, 29, 9, 29, 8, 9, 28, 8, 8, 9, 29, 29, 28, 9, 9, 8, 8, 28, 28, 29, 9, 28, 9, 9, 8, 9, 9,
        9, 9, 9, 29, 29, 9, 28, 28, 9, 8, 9, 9, 28, 9, 9, 9, 28, 9, 8, 29, 29, 9, 9, 28, 28, 29, 28, 9, 8, 9, 8, 8, 28, 8, 28, 28,
        9, 29, 28, 9, 28, 28, 28, 29, 8, 8, 28, 8, 28, 29, 9, 8, 9, 28, 9, 28, 28, 29, 29, 9, 28, 28, 8, 28, 29, 8, 9, 9, 8, 9, 9, 9,
        8, 28, 9, 8, 8, 29, 9, 29, 9, 28, 28, 9, 28, 28, 8, 28, 9, 29, 9, 28, 29, 29, 8, 28, 28, 28, 29, 8, 28, 9, 8, 29, 9, 9, 29, 9,
        28, 9, 8, 8, 8, 28, 29, 8, 9, 29, 28, 9, 9, 9, 9, 8, 29, 8, 28, 29, 9, 28, 28, 29, 28, 8, 9, 28, 28, 9, 8, 8, 8, 29, 9, 8,
        8, 9, 29, 28, 29, 29, 8, 8, 9, 9, 9, 9, 9, 28, 29, 29, 8, 29, 8, 8, 29, 8, 28, 9, 28, 9, 28, 28, 9, 8, 28, 28, 28, 9, 8, 9,
        29, 29, 29, 8, 8, 9, 28, 9, 9, 8, 28, 9, 28, 28, 8, 28, 29, 28, 29, 29, 8, 29, 9, 28, 28, 29, 9, 9, 28, 28, 8, 28, 29, 8, 9, 8,
        9, 8, 28, 28, 29, 9, 28, 9, 8, 29, 29, 29, 9, 29, 29, 9, 9, 28, 29, 29, 28, 9, 28, 28, 8, 8, 8, 29, 8, 9, 28, 8, 28, 29, 9, 29,
        28, 28, 9, 28, 8, 28, 28, 8, 9, 28, 8, 8, 28, 29, 9, 9, 8, 28, 29, 28, 9, 29, 29, 9, 8, 29, 9, 28, 8, 9, 8, 8, 9, 8, 9, 8,
        9, 29, 9, 9, 8, 29, 28, 9, 8, 8, 28, 28, 8, 29, 9, 29, 29, 8, 9, 8, 28, 9, 9, 9, 29, 29, 8, 9, 9, 9, 8, 8, 9, 28, 28, 29,
        8, 8, 8, 29, 29, 28, 29, 9, 9, 29, 9, 28, 28, 8, 8, 29, 8, 8, 8, 29, 28, 29, 9, 29, 29, 29, 28, 8, 29, 28, 9, 29, 29, 28, 29, 9,
        9, 9, 29, 9, 8, 28, 8, 9, 8, 29, 8, 8, 28, 9, 29, 29, 28, 28, 9, 8, 9, 9, 9, 29, 8, 29, 8, 28, 9, 29, 28, 8, 8, 28, 8, 28,
        29, 29, 29, 28, 9, 8, 29, 28, 9, 9, 8, 28, 28, 9, 9, 29, 9, 9, 29, 29, 28, 8, 29, 9, 29, 9, 28, 28, 9, 9, 28, 8, 8, 29, 8, 28,
        28, 8, 9, 9, 28, 28, 28, 8, 9, 8, 28, 29, 9, 29, 28, 8, 9, 8, 9, 8, 8, 9, 8, 29, 28, 8, 28, 29, 9, 28, 9, 28, 9, 29, 29, 9,
        8, 29, 9, 9, 8, 9, 29, 9, 28, 28, 8, 8, 9, 8, 8, 29, 9, 8, 8, 9, 29, 9, 9, 28, 29, 29, 8, 9, 28, 28, 28, 9, 8, 28, 29, 9,
        29, 8, 9, 29, 29, 8, 8, 28, 9, 28, 28, 29, 28, 28, 9, 29, 28, 9, 8, 29, 9, 28, 9, 28, 9, 8, 9, 9, 9, 29, 29, 8, 29, 8, 29, 29,
        9, 28, 29, 28, 28, 9, 28, 29, 8, 9, 9, 9, 8, 28, 28, 29, 29, 29, 8, 28, 28, 9, 9, 9, 29, 29, 8, 28, 9, 29, 8, 29, 29, 29, 29, 28,
        9, 29, 28, 9, 9, 9, 28, 8, 9, 8, 9, 28, 29, 29, 8, 8, 29, 28, 9, 8, 8, 29, 28, 8, 8, 28, 8, 8, 9, 8, 28, 9, 29, 29, 29, 29,
        8, 29, 29, 9, 8, 29, 9, 28, 28, 8, 9, 8, 28, 9, 8, 8, 29, 8, 8, 28, 8, 29, 28, 29, 28, 9, 8, 28, 8, 9, 28, 29, 29, 29, 8, 29,
        28, 9, 8, 29, 8, 28, 29, 8, 8, 29, 8, 29, 9, 9, 9, 28, 9, 8, 29, 29, 8, 9, 9, 9, 9, 28, 9, 8, 8, 9, 28, 9, 8, 8, 28, 8,
        9, 8, 28, 28, 29, 28, 28, 8, 29, 29, 28, 28, 8, 29, 28, 29, 8, 9, 9, 28, 28, 29, 29, 9, 29, 29, 9, 29, 28, 8, 29, 28, 9, 29, 9, 8,
        8, 28, 8, 29, 9, 29, 29, 28, 8, 8, 29, 8, 8, 28, 28, 29, 9, 9, 28, 28, 29, 29, 28, 8, 29, 28, 28, 29, 8, 8, 28, 9, 28, 28, 28, 8,
        9, 8, 8, 28, 8, 9, 29, 8, 8, 29, 9, 28, 8, 8, 29, 9, 28, 9, 29, 24, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23,
        9, 9, 8, 29, 28, 28, 28, 29, 28, 8, 8, 29, 9, 9, 9, 8, 29, 28, 28, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        29, 9, 9, 8, 29, 29, 29, 8, 9, 8, 28, 29, 28, 9, 28, 8, 9, 8, 9, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        9, 8, 9, 9, 28, 8, 9, 9, 9, 29, 28, 29, 29, 9, 8, 8, 29, 28, 9, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21,
        9, 8, 28, 28, 29, 28, 28, 28, 9, 9, 9, 9, 9, 28, 8, 9, 9, 9, 29, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        29, 29, 9, 28, 9, 28, 8, 9, 28, 28, 9, 28, 9, 8, 29, 8, 29, 8, 28, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        28, 8, 9, 28, 28, 8, 28, 9, 28, 28, 28, 29, 28, 9, 8, 9, 29, 29, 9, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        28, 29, 29, 8, 28, 8, 9, 8, 8, 8, 8, 28, 9, 8, 28, 28, 28, 29, 29, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27, 5,
        8, 29, 9, 29, 29, 9, 28, 29, 9, 9, 9, 8, 8, 8, 29, 9, 9, 28, 9, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 3, 28,
        28, 29, 9, 8, 8, 8, 29, 8, 9, 29, 29, 9, 8, 9, 8, 9, 29, 8, 9, 28, 29, 28, 28, 28, 29, 28, 28, 8, 8, 9, 9, 28, 9, 9, 29, 9
      }
    },
    {
      type = "objectgroup",
      name = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 10,
          name = "lower_level",
          type = "exit",
          shape = "rectangle",
          x = 560,
          y = 480,
          width = 32,
          height = 48,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
