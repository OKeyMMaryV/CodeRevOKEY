﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	КадровыйУчет.СформироватьКадровыеДвижения(ЭтотОбъект, Движения, ДанныеДляПроведения.КадровыеДвижения);
	
	КадровыйУчет.СформироватьДвиженияВидовЗанятостиСотрудников(Движения, ДанныеДляПроведения.ДвиженияВидовЗанятости);
	
	СтруктураПлановыхНачислений = Новый Структура;
	СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеДляПроведения.ПлановыеНачисления);
	
	РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
	РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат(Движения, ДанныеДляПроведения.КадровыеДвижения);
	
	УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииВУчетаСтажаПФР());

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДатаПриема = ТекущаяДатаСеанса();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, Истина, Ложь)
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Сотрудник") Тогда
			Сотрудник = ДанныеЗаполнения.Сотрудник;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ДатаПриема") Тогда
			ДатаПриема = ДанныеЗаполнения.ДатаПриема;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаПриема, "Объект.ДатаПриема", Отказ, НСтр("ru='Дата приема'"));
	
	КадровыйУчет.ПроверитьВозможностьПроведенияПоКадровомуУчету(
		ДатаПриема,
		Сотрудник,
		Ссылка,
		Отказ,
		Перечисления.ВидыКадровыхСобытий.Прием);
		
	КадровыйУчет.ПроверитьСоответствиеСотрудниковОрганизации(Организация, Сотрудник, Отказ);
	
	СообщениеПроверкиВидЗанятости = СотрудникиФормы.СообщениеОКонфликтеВидаЗанятостиНовогоСотрудникаССуществующими(
		Сотрудник,
		ФизическоеЛицо,
		Организация,
		ВидЗанятости,
		ДатаПриема);
		
	Если Не ПустаяСтрока(СообщениеПроверкиВидЗанятости) Тогда
		ОбщегоНазначения.СообщитьПользователю(СообщениеПроверкиВидЗанятости, , "ВидЗанятости", "Объект", Отказ);
	КонецЕсли;
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ПриемНаРаботу.ЗаполнитьДатуЗапретаРедактирования(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает данные для формирования движений.
// Возвращает Структуру с полями.
//		КадровыеДвижения - данные, необходимые для формирования 
//				- кадровой истории (см. КадровыйУчетРасширенный.СформироватьКадровыеДвижения)
//				- авансов (см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхВыплат)
//				- истории применяемых графиков работы (см. КадровыйУчетРасширенный.СформироватьИсториюИзмененияГрафиков).
//		ПлановыеНачисления - данные, необходимые для формирования истории плановых начислений.
//		(см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений)
//		ЗначенияПоказателей (см. там же).
//
Функция ПолучитьДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПриемНаРаботу.ДатаПриема КАК ДатаСобытия,
	|	ПриемНаРаботу.Сотрудник КАК Сотрудник,
	|	ПриемНаРаботу.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ПриемНаРаботу.Организация КАК Организация,
	|	ПриемНаРаботу.Подразделение КАК Подразделение,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием) КАК ВидСобытия,
	|	ПриемНаРаботу.Должность КАК Должность,
	|	ПриемНаРаботу.ВидЗанятости КАК ВидЗанятости,
	|	ПриемНаРаботу.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ПриемНаРаботу.Аванс КАК Аванс,
	|	ПриемНаРаботу.СпособРасчетаАванса КАК СпособРасчетаАванса
	|ИЗ
	|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
	|ГДЕ
	|	ПриемНаРаботу.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПриемНаРаботуНачисления.Ссылка.ДатаПриема КАК ДатаСобытия,
	|	ПриемНаРаботуНачисления.Ссылка.Сотрудник КАК Сотрудник,
	|	ПриемНаРаботуНачисления.Начисление КАК Начисление,
	|	ПриемНаРаботуНачисления.Размер КАК Размер,
	|	ПриемНаРаботуНачисления.Ссылка.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ПриемНаРаботуНачисления.Ссылка.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ИЗ
	|	Документ.ПриемНаРаботу.Начисления КАК ПриемНаРаботуНачисления
	|ГДЕ
	|	ПриемНаРаботуНачисления.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПриемНаРаботу.Ссылка КАК Ссылка,
	|	ПриемНаРаботу.Ссылка.Организация КАК Организация,
	|	ПриемНаРаботу.ДатаПриема КАК ДатаСобытия,
	|	ПриемНаРаботу.ДатаПриема КАК Период,
	|	ПриемНаРаботу.Сотрудник КАК Сотрудник,
	|	ПриемНаРаботу.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ПриемНаРаботу.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ПриемНаРаботу.ВидЗанятости КАК ВидЗанятости
	|ИЗ
	|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
	|ГДЕ
	|	ПриемНаРаботу.Ссылка = &Ссылка";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДляПроведения = Новый Структура; 
	
	// Первый набор данных для проведения - таблица для формирования кадровых движений, истории графиков, авансов.
	ДанныеДляПроведения.Вставить("КадровыеДвижения", РезультатыЗапроса[0].Выгрузить());
	
	// Второй набор данных для проведения - таблица для формирования плановых начислений.
	ДанныеДляПроведения.Вставить("ПлановыеНачисления", РезультатыЗапроса[1].Выгрузить());
	
	// Второй набор данных для проведения - таблица для формирования плановых начислений.
	ДанныеДляПроведения.Вставить("ДвиженияВидовЗанятости", РезультатыЗапроса[2].Выгрузить());
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР()
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	
	ДанныеДляРегистрацииВУчете = Документы.ПриемНаРаботу.ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок);
		
	Возврат ДанныеДляРегистрацииВУчете[Ссылка];
														
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли