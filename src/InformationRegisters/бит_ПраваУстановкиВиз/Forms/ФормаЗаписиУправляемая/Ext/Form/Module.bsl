﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.бит_ПраваУстановкиВиз;
		
	бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
    // Параметры выбора пользовательского условия.
	МассивПараметров = Новый Массив;
	
	НовыйПараметр   = Новый ПараметрВыбора("Отбор.КонтекстВыполнения", Перечисления.бит_КонтекстыВыполненияПользовательскихУсловий.ТекущийОбъект);
	МассивПараметров.Добавить(НовыйПараметр);	
	
	Элементы.ПользовательскоеУсловие.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	// Заместителя не копируем
	флЭтоЗам = ЗначениеЗаполнено(Запись.Замещаемый);
	Если НЕ Параметры.ЗначениеКопирования.Пустой() Тогда	
		Запись.Замещаемый = Справочники.Пользователи.ПустаяСсылка();	
	КонецЕсли; 
	
	Элементы.ГруппаЗамещение.Видимость = флЭтоЗам;
	Если флЭтоЗам Тогда
	
		ЭтаФорма.ТолькоПросмотр = Истина;
		
		ПарамЗаместителя = РегистрыСведений.бит_НазначенныеЗаместители.КонструкторПараметрыНазначенияЗаместителя();
		ЗаполнитьЗначенияСвойств(ПарамЗаместителя, Запись);
		ПарамЗаместителя.Заместитель = Запись.Пользователь;
		ПарамЗаместителя.Пользователь = Запись.Замещаемый;
		Элементы.ДекорацияИнфоПериодЗамещения.Заголовок = РегистрыСведений.бит_НазначенныеЗаместители.ПредставлениеПериодаЗамещения(ПарамЗаместителя);
		
	КонецЕсли;
	
	//+СБ Пискунова 15.02.2017 #2691 
	//Добавим реквизиты на формы
	СБ_РаботаСФормамиОбъекты.бит_ПраваУстановкиВизФормаЗаписиУправляемаяПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	//-СБ Пискунова15.02.2017 #2691
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокТипов = Новый СписокЗначений;
	СписокТипов.Добавить(Тип("СправочникСсылка.Пользователи")       , "Пользователи");
	СписокТипов.Добавить(Тип("СправочникСсылка.ГруппыПользователей"), "Группы пользователей");	
	
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
	                                                   ,Элемент
	                                                   ,Запись
	                                                   ,"Пользователь"
													   ,СписокТипов
													   ,СтандартнаяОбработка);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.ВыбиратьТип = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВизаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокТипов = Новый СписокЗначений;
	СписокТипов.Добавить(Тип("СправочникСсылка.бит_Визы")     , "Визы");
	СписокТипов.Добавить(Тип("СправочникСсылка.бит_ГруппыВиз"), "Группы виз");	
	
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
	                                                   ,Элемент
	                                                   ,Запись
	                                                   ,"Виза"
													   ,СписокТипов
													   ,СтандартнаяОбработка);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВизаОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.ВыбиратьТип = Истина;
	
КонецПроцедуры

#КонецОбласти

// BIT AMerkulov 11022014 ++
&НаКлиенте
Процедура ИнициаторПриИзменении(Элемент)
	
	ИнициаторПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ИнициаторПриИзмененииНаСервере()
	
	Запись.Пользователь = Запись.Инициатор.Пользователь;
	
КонецПроцедуры
// BIT AMerkulov 11022014 --
