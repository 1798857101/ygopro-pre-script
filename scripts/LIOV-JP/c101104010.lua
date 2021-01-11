--紅蓮薔薇の魔女

--Scripted by mallu11
function c101104010.initial_effect(c)
	aux.AddCodeList(c,73580471)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104010,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101104010)
	e1:SetCost(c101104010.thcost)
	e1:SetTarget(c101104010.thtg)
	e1:SetOperation(c101104010.thop)
	c:RegisterEffect(e1)
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101104010,1))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101104110)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101104010.tetg)
	e2:SetOperation(c101104010.teop)
	c:RegisterEffect(e2)
end
function c101104010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_EFFECT)
end
function c101104010.thfilter(c,tp,solve)
	return c:IsCode(17720747) and c:IsAbleToHand() and (solve or Duel.IsExistingMatchingCard(c101104010.dtfilter,tp,LOCATION_DECK,0,1,c))
end
function c101104010.dtfilter(c)
	return c:IsLevelBelow(3) and c:IsRace(RACE_PLANT)
end
function c101104010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104010.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
end
function c101104010.sumfilter(c)
	return c:IsCode(17720747) and c:IsSummonable(true,nil)
end
function c101104010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101104010.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp,true)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101104010,2))
		local dg=Duel.SelectMatchingCard(tp,c101104010.dtfilter,tp,LOCATION_DECK,0,1,1,nil)
		local dc=dg:GetFirst()
		if dc then
			Duel.MoveSequence(dc,0)
			if Duel.IsExistingMatchingCard(c101104010.sumfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101104010,3)) then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local sg=Duel.SelectMatchingCard(tp,c101104010.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
				local sc=sg:GetFirst()
				if sc then
					Duel.Summon(tp,sc,true,nil)
				end
			end
		end
	end
end
function c101104010.tefilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCode(73580471,101104035) and c:IsAbleToExtra()
end
function c101104010.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104010.tefilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c101104010.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101104010.tefilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end