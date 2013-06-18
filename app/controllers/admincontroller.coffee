module.exports = (app) ->
	class app.admincontroller

		#ADMIN
		# Admin servers
		@adminservers = (req, res) ->
			app.dao.getServers (data) ->
				res.render 'adminservers', title: 'Servers', servers: data

		@toggleServer = (req, res) ->
			app.dao.toggleServer req.params.id, (data) ->
				res.end JSON.stringify data

		@unvalServer = (req, res) ->
			app.dao.unvalServer req.params.id, (data) ->
				res.json data

		@editServer = (req, res) ->
			app.dao.editServer req.body, (data) ->
				res.redirect '/admin/servers'

		@delServer = (req, res) ->
			app.dao.delServer req.params.id, (data) ->
				res.json data

		@editServerModal = (req, res) ->
			app.dao.getServer req.params.id, (data) ->
				res.render 'editservermodal', server: data[0]

		# Admin sites	
		@adminsites = (req, res) ->
			app.dao.getSites (data) ->
				res.render 'adminsites', title: 'Sites', sites: data

		@delSite = (req, res) ->
			app.dao.delSite req.params.id, (data) ->
				res.json data

		@cleanSites = (req, res) ->
			app.ip.cleanSites (data) ->
				res.redirect '/admin/sites'