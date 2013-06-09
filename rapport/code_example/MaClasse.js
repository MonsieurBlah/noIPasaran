var MaClasse = (function() {
		function MaClass() {
			alert('Constructeur')
		}

		MaClasse.prototype.faitQQChose = function() {
			alert('fait quelque chose')
		};

		return MaClasse;
	})();

	c = new MaClasse();
	c.faitQQChose();