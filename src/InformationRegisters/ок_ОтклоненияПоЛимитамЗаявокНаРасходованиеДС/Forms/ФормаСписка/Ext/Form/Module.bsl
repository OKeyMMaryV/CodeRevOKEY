
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтборПоЦФО();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборЦФОПриИзменении(Элемент)
	
	УстановитьОтборПоЦФО();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоЦФО()
	
	Список.Параметры.УстановитьЗначениеПараметра("ОтборЦФО", ?(ЗначениеЗаполнено(ЦФО), ЦФО, Неопределено));
	
КонецПроцедуры