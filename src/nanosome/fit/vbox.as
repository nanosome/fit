// @license
package nanosome.fit {
	/**
	 * @author mh
	 */
	public function vbox( halign: HAlign, ...elements: Array ): VBoxLayout {
		var vBox: VBoxLayout = new VBoxLayout( halign );
		vBox.addChildren( elements );
		return vBox;
	}
}
