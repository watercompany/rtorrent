package main

import (
	"flag"

	"github.com/gin-gonic/gin"
	"github.com/mrobinsn/go-rtorrent/rtorrent"
)

func main() {
	uriFlag := flag.String("uri", "http://localhost/plugins/httprpc/action.php", "RPC URI")
	portFlag := flag.String("port", "9090", "Port")
	flag.Parse()

	rt := rtorrent.New(*uriFlag, true)
	var view rtorrent.View
	view = "main"

	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()
	r.GET("/", func(c *gin.Context) {
		torrents, err := rt.GetTorrents(view)
		if err != nil {
			panic(err)
		}
		c.JSON(200, torrents)
	})

	r.Run("0.0.0.0:" + *portFlag)
}
