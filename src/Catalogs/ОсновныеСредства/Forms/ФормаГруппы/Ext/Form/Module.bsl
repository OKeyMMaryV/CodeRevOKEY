#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	//++ СВВ {[+](фрагмент добавлен), Сапожников Вадим 17.07.2015 12:06:16
	ИжТиСи_СВД_Сервер.ОК_ВывестиРеквизиты(ЭтаФорма, "Справочник.ОсновныеСредства.ФормаГруппы");
	//-- СВВ}Сапожников Вадим 17.07.2015 12:06:16
	
КонецПроцедуры

#КонецОбласти
