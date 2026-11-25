// fix
function postCreate()
{
	remove(healthBarBG, true);
	insert(members.indexOf(healthBar) + 1, healthBarBG);
}