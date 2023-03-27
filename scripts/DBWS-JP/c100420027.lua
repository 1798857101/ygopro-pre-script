--VS 龍帝ノ槍
function c100420027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,100420027+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100420027.condition)
	e1:SetTarget(c100420027.target)
	e1:SetOperation(c100420027.activate)
	c:RegisterEffect(e1)
end
function c100420027.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x195)
end
function c100420027.cfilter2(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function c100420027.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c100420027.cfilter2,1,nil,tp) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c100420027.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c100420027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100420027.dmgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x195) and c:GetAttack()>0
end
function c100420027.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev)
		and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0
		and Duel.IsExistingMatchingCard(c100420027.dmgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100420027,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c100420027.dmgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Damage(1-tp,g:GetFirst():GetAttack(),REASON_EFFECT)
	end
end