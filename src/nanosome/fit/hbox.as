// @license
package nanosome.fit {
	/**
	 * @author mh
	 */
	public function hbox( valign: VAlign, ...elements: Array ): HBoxLayout {
		var hBox: HBoxLayout = new HBoxLayout( valign );
		hBox.addChildren( elements );
		return hBox;
	}
}
