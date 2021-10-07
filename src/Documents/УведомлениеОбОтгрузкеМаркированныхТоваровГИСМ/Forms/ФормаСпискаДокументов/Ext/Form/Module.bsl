﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПереопределитьТекстЗапросаСпискаКОформлению();
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ОрганизацияОтбор.Видимость = ИнтеграцияГИСМ.ИспользоватьНесколькоОрганизаций();
	Элементы.ОрганизацияКОформлениюОтбор.Видимость = ИнтеграцияГИСМ.ИспользоватьНесколькоОрганизаций();
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокКОформлению, "СтатусГИСМ", СтатусГИСМУведомленияКОформлению, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокКОформлению, "Организация", Организация, СтруктураБыстрогоОтбора);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "СтатусГИСМ",СтатусГИСМ, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Организация", Организация, СтруктураБыстрогоОтбора);
	
	Если ИнтеграцияГИСМКлиентСервер.НеобходимОтборПоДальнейшемуДействиюГИСМПриСозданииНаСервере(ДальнейшееДействиеГИСМ, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	ИнтеграцияГИСМ.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.ДальнейшееДействиеГИСМОтбор.СписокВыбора,
		ВсеТребующиеДействия(),
		ВсеТребующиеОжидания());
		
	Если Параметры.ОткрытьРаспоряжения Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаКОформлению;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокКОформлению,
	                                                                     "СтатусГИСМУведомленияКОформлению",
	                                                                     СтатусГИСМУведомленияКОформлению,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                     "СтатусГИСМ",
	                                                                     СтатусГИСМ,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	Если ИнтеграцияГИСМКлиентСервер.НеобходимОтборПоДальнейшемуДействиюГИСМПередЗагрузкойИзНастроек(ДальнейшееДействиеГИСМ, СтруктураБыстрогоОтбора, Настройки) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                     "Ответственный",
	                                                                     Ответственный,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	ЗначОрганизация = Настройки.Получить("Организация"); 
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокКОформлению,
	                                                                     "Организация",
	                                                                     Организация,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	Если ЗначОрганизация <> Неопределено Тогда
		Настройки.Вставить("Организация", ЗначОрганизация);
	КонецЕсли;
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                     "Организация",
	                                                                     Организация,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ" Тогда
		Элементы.Список.Обновить();
		Элементы.СписокКОформлению.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "#ГИСМ#ИзменениеСостоянияГИСМ"
		И ТипЗнч(Параметр.Ссылка) = Тип("ДокументСсылка.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ") Тогда
		
		Элементы.Список.Обновить();
		Элементы.СписокКОформлению.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "#ГИСМ#ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		Элементы.Список.Обновить();
		Элементы.СписокКОформлению.Обновить();
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура АрхивироватьДокументы(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Элементы.Список, ИнтеграцияГИСМКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура Архивировать(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьРаспоряжения(ЭтотОбъект, Элементы.СписокКОформлению, ИнтеграцияГИСМКлиент,
		ПредопределенноеЗначение("Документ.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ.ПустаяСсылка"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьУведомлениеОбОтгрузке(Команда)
	
	ОчиститьСообщения();
	
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиДинамическогоСпискаКорректен(Элементы.СписокКОформлению) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Основание", Элементы.СписокКОформлению.ТекущиеДанные.Документ);
	ОткрытьФорму("Документ.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ.Форма.ФормаДокумента",ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Ответственный",
	                                                                        Ответственный,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Ответственный));
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКОформлению,
	                                                                        "Организация",
	                                                                        Организация,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Организация));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Организация",
	                                                                        Организация,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМУведомленияКОформлениюОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКОформлению,
	                                                                        "СтатусГИСМУведомленияКОформлению",
	                                                                        СтатусГИСМУведомленияКОформлению,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(СтатусГИСМУведомленияКОформлению));
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "СтатусГИСМ",
	                                                                        СтатусГИСМ,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(СтатусГИСМ));
	
КонецПроцедуры

&НаКлиенте
Процедура ДальнейшееДействиеГИСМОтборПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СписокКОформлению.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент.Имя = "СписокКОформлениюУведомление"
		И ЗначениеЗаполнено(ТекущиеДанные.ТекущееУведомление)Тогда
		
		ПоказатьЗначение( ,ТекущиеДанные.ТекущееУведомление);
		
	Иначе
		
		ПоказатьЗначение( ,ТекущиеДанные.Документ);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ДальнейшееДействиеГИСМ Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
			Элементы.Список,
			Элемент.ДанныеСтроки(ВыбраннаяСтрока).ДальнейшееДействиеГИСМ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СписокСтатусовОтказ = Новый СписокЗначений;
	СписокСтатусовОтказ.Добавить(Перечисления.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ОтклоненоГИСМ);
	СписокСтатусовОтказ.Добавить(Перечисления.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ОтклоненоКлиентом);
	
	// Условное оформление динамического списка Список
	
	СписокУсловноеОформление = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеСтатусДальнейшееДействиеГИСМ(
		СписокУсловноеОформление,
		Элементы,
		Элементы.СтатусГИСМ.Имя,
		Элементы.ДальнейшееДействиеГИСМ.Имя,
		"СтатусГИСМ",
		"ДальнейшееДействиеГИСМ");
		
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеНомерГИСМ(
		СписокУсловноеОформление,
		Элементы,
		Элементы.НомерГИСМ.Имя,
		"НомерГИСМ");
	
	// Цвет текста серый
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусГИСМ.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусГИСМ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Закрыто;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
		
	// Цвет текста проблема
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусГИСМ.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусГИСМ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокСтатусовОтказ;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
	
	// Условное оформление динамического списка СписокКОформлению
	
	СписокУсловноеОформление = СписокКОформлению.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеНомерГИСМ(
		СписокУсловноеОформление,
		Элементы,
		Элементы.СписокКОформлениюНомерГИСМ.Имя,
		"НомерГИСМ");
	
	// Цвет текста серый
	Элемент = СписокУсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусГИСМУведомленияКОформлению.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СтатусГИСМУведомленияКОформлению");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Закрыто;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
	// Цвет текста проблема 
	Элемент = СписокУсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусГИСМУведомленияКОформлению.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СтатусГИСМУведомленияКОформлению");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокСтатусовОтказ;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
	
КонецПроцедуры

#Область ОтборДальнейшиеДействия

&НаСервереБезКонтекста
Функция ВсеТребующиеДействия()
	
	МассивДействий = Новый Массив();
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные);
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ") Тогда
		МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен);
	КонецЕсли;
	
	Возврат МассивДействий;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеТребующиеОжидания()
	
	МассивДействий = Новый Массив();
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ") Тогда
		МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	КонецЕсли;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПодтверждениеПолучения);
	
	Возврат МассивДействий;
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияГИСМ.УстановитьОтборПоДальнейшемуДействию(Список, ДальнейшееДействиеГИСМ, ВсеТребующиеДействия(), ВсеТребующиеОжидания());
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПереопределитьТекстЗапросаСпискаКОформлению()
	
	ТекстЗапроса = "";
	ИнтеграцияГИСМПереопределяемый.ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОбОтгрузке(ТекстЗапроса);
	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокКОформлению, СвойстваСписка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
