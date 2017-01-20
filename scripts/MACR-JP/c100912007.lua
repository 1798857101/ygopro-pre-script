--SRアクマグネ
--Speedroid Fiendmagnet
--Scripted by Eerie Code and mercury233
function c100912007.initial_effect(c)
	--cannot be synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c100912007.smcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100912007,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c100912007.spcon)
	e2:SetTarget(c100912007.sptg)
	e2:SetOperation(c100912007.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c100912007.smcon(e)
	return e:GetHandler():GetFlagEffect(100912007)==0
end
function c100912007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and bit.band(Duel.GetCurrentPhase(),PHASE_MAIN1+PHASE_MAIN2)>0
end
function c100912007.filter(tc,c,tp)
	if not tc:IsFaceup() or not tc:IsCanBeSynchroMaterial() then return false end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
	tc:RegisterEffect(e1)
	local mg=Group.FromCards(c,tc)
	local res=Duel.IsExistingMatchingCard(c100912007.synfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	e1:Reset()
	return res
end
function c100912007.synfilter(c,mg)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSynchroSummonable(nil,mg)
end
function c100912007.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	c:RegisterFlagEffect(100912007,0,0,1)
	if chkc then
		local res=chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100912007.filter(chkc,c,tp)
		c:ResetFlagEffect(100912007)
		return res
	end
	if chk==0 then
		local res=Duel.IsExistingTarget(c100912007.filter,tp,0,LOCATION_MZONE,1,nil,c,tp)
		c:ResetFlagEffect(100912007)
		return res
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100912007.filter,tp,0,LOCATION_MZONE,1,1,nil,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	c:ResetFlagEffect(100912007)
end
function c100912007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		c:RegisterFlagEffect(100912007,0,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e1)
		local mg=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100912007.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		local sc=g:GetFirst()
		if sc then
			Duel.SynchroSummon(tp,sc,nil,mg)
		end
		c:ResetFlagEffect(100912007)
		e1:Reset()
	end
end
