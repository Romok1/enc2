export const mixinCarto = {
  data () {
    return {
      layerObject: '',
    }
  },

  methods: {
    createTiles (username, key, { filter, cartoTables }) {
      let tiles = new cartodb.Tiles({
        user_name: username,
        tiler_protocol: 'https',
        tiler_port: '443',
        sublayers: [{
          //change table_name with name of the dataset
          //best to use .env
          sql: this.generateSQL(filter, cartoTables),
          cartocss: this.generateCartocss(cartoTables)
        }],
        extra_params: { map_key: key }
      })

      return tiles
    },

    generateSQL (filter, tables) {
      let sql = ''
      let whereCond = ''

      if(filter !== undefined && filter !== null) {
        whereCond = ' WHERE ' + filter
      }

      let defaultSql = 'SELECT cartodb_id, the_geom, the_geom_webmercator'

      if (tables[0] === 'wdpa_poly') {
        defaultSql += ', name, desig_eng, gov_type, iucn_cat, wdpaid'
      }

      if (tables[0] === 'global_kba_poly') {
        defaultSql += ', intname, ibastatus, azestatus'
      }

      defaultSql += ' FROM '

      tables.forEach((table, index) => {
        sql = sql + defaultSql + table + whereCond

        if (index < tables.length - 1) {
          sql = sql + ' UNION ALL '
        }
      })

      return sql
    },

    generateCartocss(tables) {
      let css = ''

      // const attributes = {
      //   'opacity': '0.6',
      //   'line-width': '0.1',
      //   'polygon-comp-op': 'dst-over'
      // }

      tables.forEach((table, index) => {
        css = css + '#' + table + '{'
        //const attributes = Object.entries(this.$store.state.carto.cartocss)
        // attributes.forEach((attr, index) => {
        //   css = css + attr[0] + ':' + attr[1]
        //   if (index < attributes.length - 1) {
        //     css = css + ';'
        //   }
        // })
        css = css + '}'
        if (index < tables.length - 1) {
          css = css + '\n'
        }
      })

      return css
    }
  }
}
