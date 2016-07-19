part of config;

Map config = {
  "selectors": {
    "containers": [
      ".ingredients-list ul",
      "ul.svtmat_recipe__ingredients-list",
      ".ingredients .ingredient-group ul",
      ".ingredients ul",
      ".recipeIngredients ul",
      ".ingredients"
    ],
    "itemProps": [
      "[itemprop=ingredient]",
      "[itemprop=ingredients]",
      "[itemprop=recipeIngredient]",
      ".ingredient"
    ],
    "amount": [
      ".yield",
      "[itemprop=recipeYield]",
      "[itemprop=yield]",
      "[itemprop= yield]",
      "#recipeServingsDefaultValueRWD"
    ]
  },
  "types": [
    {"id": 1, "sv": "lagrad"},
    {"id": 2, "sv": "torkade"},
    {"id": 3, "sv": "torkad"},
    {"id": 4, "sv": "färska"},
    {"id": 5, "sv": "färsk"},
    {"id": 6, "sv": "viskpad"},
    {"id": 7, "sv": "fryst"},
    {"id": 8, "sv": "fast"},
    {"id": 9, "sv": "färdigkokta"},
    {"id": 10, "sv": "flytande"},
    {"id": 11, "sv": "färdigkokt"},
    {"id": 12, "sv": "kokta"},
    {"id": 13, "sv": "inlagd"},
    {"id": 14, "sv": "kokt"},
    {"id": 15, "sv": "gravade"},
    {"id": 16, "sv": "gravad"},
    {"id": 17, "sv": "rökta"},
    {"id": 18, "sv": "rökt"},
    {"id": 19, "sv": "inlagd"},
    {"id": 20, "sv": "vanliga"},
    {"id": 21, "sv": "fint"},
    {"id": 22, "sv": "grovmalen"},
    {"id": 23, "sv": "finmalen"},
    {"id": 24, "sv": "malen"},
    {"id": 25, "sv": "finriven"},
    {"id": 26, "sv": "riven"},
    {"id": 27, "sv": "krossade"},
    {"id": 28, "sv": "krossad"},
    {"id": 29, "sv": "skalade"},
    {"id": 30, "sv": "skalad"},
    {"id": 31, "sv": "hackade"},
    {"id": 32, "sv": "hackad"},
    {"id": 33, "sv": "färskpressad"},
    {"id": 34, "sv": "pressad"},
    {"id": 35, "sv": "halstrad"},
    {"id": 36, "sv": "nymald"},
    {"id": 37, "sv": "nymalen"},
    {"id": 38, "sv": "marinerade"},
    {"id": 39, "sv": "grovhackad"},
    {"id": 40, "sv": "stora"},
    {"id": 41, "sv": "stor"},
    {"id": 42, "sv": "små"},
    {"id": 43, "sv": "skivat"},
    {"id": 44, "sv": "finhackad"},
    {"id": 45, "sv": "frysta"},
    {"id": 46, "sv": "hela"},
    {"id": 47, "sv": "smält"},
    {"id": 48, "sv": "skuren"}
  ],
  "measurements": [
    {"id": 1, "sv": "klyfta"},
    {"id": 2, "sv": "klyftor"},
    {"id": 3, "sv": "st klyftor"},
    {"id": 4, "sv": "kg"},
    {"id": 5, "sv": "dl"},
    {"id": 6, "sv": "st"},
    {"id": 7, "sv": "stycken"},
    {"id": 8, "sv": "stycke"},
    {"id": 9, "sv": "g"},
    {"id": 10, "sv": "kilo"},
    {"id": 11, "sv": "hg"},
    {"id": 12, "sv": "hektogram"},
    {"id": 13, "sv": "msk"},
    {"id": 14, "sv": "dussin"},
    {"id": 15, "sv": "tsk"},
    {"id": 16, "sv": "hela"},
    {"id": 17, "sv": "smulad"},
    {"id": 18, "sv": "kryddmått"},
    {"id": 19, "sv": "krm"},
    {"id": 20, "sv": "gr"},
    {"id": 21, "sv": "gram"},
    {"id": 22, "sv": "cl"},
    {"id": 23, "sv": "glas"},
    {"id": 24, "sv": "centiliter"},
    {"id": 25, "sv": "deciliter"},
    {"id": 26, "sv": "liter"},
    {"id": 27, "sv": "l"},
    {"id": 28, "sv": "ml"},
    {"id": 29, "sv": "milliliter"},
    {"id": 30, "sv": "matsked"},
    {"id": 31, "sv": "tesked"},
    {"id": 32, "sv": "kruka"},
    {"id": 33, "sv": "kkp"},
    {"id": 34, "sv": "kaffekopp"},
    {"id": 35, "sv": "tekopp"},
    {"id": 36, "sv": "tkp"},
    {"id": 37, "sv": "skvätt"},
    {"id": 38, "sv": "paket"},
    {"id": 39, "sv": "pkt"},
    {"id": 40, "sv": "bit"},
    {"id": 41, "sv": "halva"},
    {"id": 42, "sv": "knippe"},
    {"id": 43, "sv": "liten bit"},
    {"id": 44, "sv": "påse"},
    {"id": 45, "sv": "näve"},
    {"id": 46, "sv": "nypa"},
    {"id": 47, "sv": "knivsudd"},
    {"id": 48, "sv": "mg"},
    {"id": 49, "sv": "port"},
    {"id": 50, "sv": "cm"},
    {"id": 51, "sv": "burk"},
    {"id": 52, "sv": "brk"},
    {"id": 53, "sv": "flaska"},
    {"id": 54, "sv": "påse"},
    {"id": 55, "sv": "ask"},
    {"id": 56, "sv": "handfull"},
    {"id": 57, "sv": "förpackning"}
  ],
  "replacements": {
    "LCHF": [
      {
        "keys": ["spaghetti", "pasta", "lasagneplattor"],
        "values": [
          {
            "title": "LCHF-pasta",
            "ingredients": [
              "6 ägg",
              "200 gram färskost",
              "0,75 dl fiberhusk",
              "1 krm salt"
            ]
          },
          {
            "title": "Zucchini",
            "ingredients": ["1 zucchini"]
          },
          {
            "title": "Strimlad vitkål",
            "ingredients": ["1 vitkålshuvud"]
          }
        ]
      },
      {
        "keys": ['baguette'],
        "values": [
          {
            "title": "Fröknäcke",
            "ingredients": ["1 pkt fröknäcke"]
          }
        ]
      },
      {
        "keys": ['tortillabröd'],
        "values": [
          {
            "title": "Salladsblad",
            "ingredients": ["1 salladshuvud"]
          }
        ]
      },
      {
        "keys": ['vetemjöl'],
        "values": [
          {
            "title": "Mandelmjöl",
            "ingredients": ["1 pkt mandelmjöl"]
          },
          {
            "title": "Äggulor",
            "ingredients": ["2 st ägg"]
          },
          {
            "title": "Philadelphiaost",
            "ingredients": ["200 g philadelphiaost"]
          }
        ]
      },
      {
        "keys": ['potatis'],
        "values": [
          {"title": "Rättika", "ingredients": []}
        ]
      },
      {
        "keys": ['ris'],
        "values": [
          {
            "title": "Blomkålsris",
            "ingredients": ["1 pkt blomkålsris eller 1 st blomkålshuvud"]
          }
        ]
      },
      {
        "keys": ['strösocker', 'socker'],
        "values": [
          {"title": "honung", "ingredients": []},
          {"title": "Sötströ", "ingredients": []}
        ]
      },
      {
        "keys": ['margarin'],
        "values": [
          {"title": "Smör", "ingredients": []}
        ]
      }
    ],
    "Gluten": [
      {
        "keys": ['spaghetti', 'pasta'],
        "values": [
          {"title": "Gluten-pasta", "ingredients": []}
        ]
      }
    ]
  }
};
