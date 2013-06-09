class MaClasse
		constructeur: ->
			alert 'constructeur'

		faitQQChose: ->
			alert 'fait quelque chose'

		c = new MaClasse()
		c.faitQQChose()