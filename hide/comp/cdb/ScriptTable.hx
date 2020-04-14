package hide.comp.cdb;

class ScriptTable extends SubTable {

	var script : hide.comp.ScriptEditor;

	override function makeSubSheet():cdb.Sheet {
		var sheet = cell.table.sheet;
		var c = cell.column;
		var index = cell.line.index;
		var key = sheet.getPath() + "@" + c.name + ":" + index;
		this.lines = [];
		return new cdb.Sheet(editor.base, {
			columns : [c],
			props : {},
			name : key,
			lines : [cell.line.obj],
			separators: [],
		}, key, { sheet : sheet, column : cell.columnIndex, line : index });
	}

	override public function close() {
		if( script != null ) saveValue();
		super.close();
	}

	function saveValue() {
		var code = [for( line in script.code.split("\r\n").join("\n").split("\n") ) StringTools.rtrim(line)].join("\n");
		cell.setValue(code);
	}

	override function refresh() {
		var first = script == null;
		element.html("<div class='cdb-script'></div>");
		var div = element.children("div");
		div.on("keypress keydown keyup", (e) -> e.stopPropagation());
		var checker = new ScriptEditor.ScriptChecker(editor.config,"cdb."+cell.getDocumentName(),[ "cdb."+cell.table.sheet.name => cell.line.obj ]);
		script = new ScriptEditor(cell.value, checker, div);
		script.onSave = saveValue;
		script.onClose = function() { close(); cell.focus(); }
		lines = [new Line(this,[],0,script.element)];
		insertedTR.addClass("code");
		if( first ) script.focus();
	}

}

