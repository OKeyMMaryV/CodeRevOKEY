﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ 

// бит_DFedotov Процедура - обработчик события "ПриСозданииНаСервере" формы
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// стандартные действия при создании на сервере
	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
	МетаданныеОбъекта = Метаданные.Документы.бит_КорректировкаКонтрольныхЗначений;
	
	// вызов механизма защиты
	бит_ЛицензированиеБФCервер.ПроверитьВозможностьРаботы(ЭтаФорма,МетаданныеОбъекта.ПолноеИмя(),Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2019-10-21 (#3393)
	ок_УправлениеФормами.бит_БК_КорректировкаКонтрольныхЗначенийИБюджетаФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-10-21 (#3393)	
	
КонецПроцедуры

//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2019-10-21 (#3393)

&НаСервере
Функция НуженВопросОчисткаАлгоритма(Знач Массив)
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	бит_УстановленныеВизы.Объект КАК Объект
	|ИЗ
	|	РегистрСведений.бит_УстановленныеВизы КАК бит_УстановленныеВизы
	|ГДЕ
	|	бит_УстановленныеВизы.Объект В(&Массив)");
	Запрос.УстановитьПараметр("Массив"	,	Массив);
	Результат = Запрос.Выполнить();
	
	Возврат Не Результат.Пустой();
	
КонецФункции

&НаКлиенте
Процедура ОК_ОтменитьПроведение(Команда)
	
	НуженВопросОчисткаАлгоритма = Ложь;
	Массив =  Элементы.Список.ВыделенныеСтроки;
	Если Массив.Количество()>0 Тогда 
		НуженВопросОчисткаАлгоритма = НуженВопросОчисткаАлгоритма(Массив);
	КонецЕсли;
	
	Если Не НуженВопросОчисткаАлгоритма Тогда 
		ОК_ОтменитьПроведениеНаСервере(Массив);	
		Элементы.Список.Обновить(); 
		Возврат;
	КонецЕсли; 
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("МассивВыделенных", Массив);
	
	ОписаниеОтветНаВопросОбОчисткеМаршрута = Новый ОписаниеОповещения("ОтветНаВопросОбОчисткеМаршрута", ЭтотОбъект, ДопПараметры);
	ПоказатьВопрос(ОписаниеОтветНаВопросОбОчисткеМаршрута, НСтр("ru = 'После отмены проведения будет очищен алгоритм. Продолжить?'"), РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет);		
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросОбОчисткеМаршрута(Результат, ДопПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
		
	ОК_ОтменитьПроведениеНаСервере(ДопПараметры.МассивВыделенных);	
	Элементы.Список.Обновить();  		
	
КонецПроцедуры

&НаСервере
Процедура ОК_ОтменитьПроведениеНаСервере(МассивДокументов) 
	
	пОшибка = НСтр("ru = 'Не удалось отменить проведение документа %1 по причине %2'");
	
	Для каждого Документ из МассивДокументов Цикл 
		
		Если НЕ Документ.Проведен Тогда 
			Продолжить;
		КонецЕсли;
		
		лДок = Документ.ПолучитьОбъект();
		Попытка
			лДок.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		Исключение			
			Ошибка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Ошибка, лДок.Ссылка, ОписаниеОшибки());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Ошибка);
		КонецПопытки;
		
	КонецЦикла;	
	
КонецПроцедуры 

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	ПодключаемыеКомандыКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-10-21 (#3393)

//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2021-04-20 (#4130)
&НаКлиенте
Процедура СоздатьОбычныйДокумент(Команда)
	
	ЗначенияЗаполнения = Новый Структура("ок_ВидКорректировки", ПредопределенноеЗначение("Перечисление.ок_ВидКорректировкиКонтрольныхЗначенийИБюджета.ПустаяСсылка"));
	СтруктураПараметров = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Документ.бит_БК_КорректировкаКонтрольныхЗначенийИБюджета.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКоррМеждуПолугодиямиБезИзмененияАналитик(Команда)
	ЗначенияЗаполнения = Новый Структура("ок_ВидКорректировки", ПредопределенноеЗначение("Перечисление.ок_ВидКорректировкиКонтрольныхЗначенийИБюджета.КоррМеждуПолугодиямиБезИзмененияАналитик"));
	СтруктураПараметров = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Документ.бит_БК_КорректировкаКонтрольныхЗначенийИБюджета.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКоррВПределахФункцийФД(Команда)
	ЗначенияЗаполнения = Новый Структура("ок_ВидКорректировки", ПредопределенноеЗначение("Перечисление.ок_ВидКорректировкиКонтрольныхЗначенийИБюджета.КоррВПределахФункцийФД"));
	СтруктураПараметров = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Документ.бит_БК_КорректировкаКонтрольныхЗначенийИБюджета.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьУвеличениеБюджета(Команда)
	ЗначенияЗаполнения = Новый Структура("ок_ВидКорректировки", ПредопределенноеЗначение("Перечисление.ок_ВидКорректировкиКонтрольныхЗначенийИБюджета.УвеличениеБюджета"));
	СтруктураПараметров = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Документ.бит_БК_КорректировкаКонтрольныхЗначенийИБюджета.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);	
КонецПроцедуры


//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2021-04-20 (#4130)