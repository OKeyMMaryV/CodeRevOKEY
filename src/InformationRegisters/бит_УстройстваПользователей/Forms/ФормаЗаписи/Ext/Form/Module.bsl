
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УстройствоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	
	СписокТипов = Новый СписокЗначений;
	СписокТипов.Добавить(Тип("СправочникСсылка.бит_МобильныеУстройства"), "Мобильные устройства");
	СписокТипов.Добавить(Тип("СправочникСсылка.бит_ЧатыTelegram"), "Чаты Telegram");	
	
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
	                                                   ,Элемент
	                                                   ,Запись
	                                                   ,"Устройство"
													   ,СписокТипов
													   ,СтандартнаяОбработка);
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура УстройствоОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.ВыбиратьТип = Истина;
	
КонецПроцедуры

#КонецОбласти
