﻿
#Область СлужебныеПроцедурыИФункции

// Получает информацию о виде расчета.
Функция ПолучитьИнформациюОВидеРасчета(ВидРасчета) Экспорт
		
	Возврат ЗарплатаКадрыВнутренний.ПолучитьИнформациюОВидеРасчета(ВидРасчета);
	
КонецФункции

// См. ЗарплатаКадры.ГоловнаяОрганизация.
Функция ГоловнаяОрганизация(Организация) Экспорт
	Возврат РегламентированнаяОтчетность.ГоловнаяОрганизация(Организация);
КонецФункции

// См. ЗарплатаКадры.ЭтоЮридическоеЛицо.
Функция ЭтоЮридическоеЛицо(Организация) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЮридическоеФизическоеЛицо") <> Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
КонецФункции

// Возвращает ссылку на "Регистрацию в налоговом органе" по состоянию на некоторую ДатаАктуальности.
Функция РегистрацияВНалоговомОргане(СтруктурнаяЕдиница, Знач ДатаАктуальности = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаАктуальности) Тогда
		ДатаАктуальности = ТекущаяДатаСеанса()
	КонецЕсли;
	
	РегистрацияВНалоговомОргане = Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница",	СтруктурнаяЕдиница);
	Запрос.УстановитьПараметр("ДатаАктуальности",	ДатаАктуальности);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИсторияРегистрацийВНалоговомОрганеСрезПоследних.РегистрацияВНалоговомОргане
	|ИЗ
	|	РегистрСведений.ИсторияРегистрацийВНалоговомОргане.СрезПоследних(&ДатаАктуальности, СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК ИсторияРегистрацийВНалоговомОрганеСрезПоследних";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.РегистрацияВНалоговомОргане;
		
	КонецЕсли;
	
	Если ТипЗнч(СтруктурнаяЕдиница) <> Тип("СправочникСсылка.Организации") Тогда
		
		ИменаРеквизитов = "Родитель,Владелец";
		Если ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
			ИменаРеквизитов = ИменаРеквизитов + ",ОбособленноеПодразделение";
		КонецЕсли;
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтруктурнаяЕдиница, ИменаРеквизитов);
		Если ТипЗнч(СтруктурнаяЕдиница) <> Тип("СправочникСсылка.ПодразделенияОрганизаций")
			Или ЗначенияРеквизитов.ОбособленноеПодразделение <> Истина Тогда
			
			Если ЗначениеЗаполнено(ЗначенияРеквизитов.Родитель) Тогда
				Возврат ЗарплатаКадрыПовтИсп.РегистрацияВНалоговомОргане(ЗначенияРеквизитов.Родитель, ДатаАктуальности);
			ИначеЕсли ЗначениеЗаполнено(ЗначенияРеквизитов.Владелец) Тогда
				Возврат ЗарплатаКадрыПовтИсп.РегистрацияВНалоговомОргане(ЗначенияРеквизитов.Владелец, ДатаАктуальности);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка();
	
КонецФункции

// Возвращает ссылку на валюту в которой происходит расчет заработной платы (рубль РФ).
// Номинирование тарифов, надбавок, выплата зарплаты допускается в любой валюте, 
// но расчеты выполняются в валюте учета зарплаты.
Функция ВалютаУчетаЗаработнойПлаты() Экспорт

	Возврат Справочники.Валюты.НайтиПоКоду("643");

КонецФункции

// Возвращает массив ссылок на виды документов удостоверяющих личность.
//
Функция ВидыДокументовУдостоверяющихЛичностьФНС() Экспорт
	КодыДокументовСтрокой = УчетНДФЛКлиентСервер.КодыДопустимыхДокументовУдостоверяющихЛичность();
	
	КодыДокументов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодыДокументовСтрокой, ",", , Истина);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодыДокументов", КодыДокументов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыДокументовФизическихЛиц.Ссылка
	|ИЗ
	|	Справочник.ВидыДокументовФизическихЛиц КАК ВидыДокументовФизическихЛиц
	|ГДЕ
	|	ВидыДокументовФизическихЛиц.КодМВД В(&КодыДокументов)";
	
	ВидыДокументов = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВидыДокументов.Добавить(Выборка.Ссылка);	
	КонецЦикла;	
	
	Возврат ВидыДокументов;
		
КонецФункции	

// Возвращает настройки формирования печатных форм.
//
// Возвращаемое значение:
// 	ФиксированнаяСтруктура - см. РегистрыСведений.ДополнительныеНастройкиЗарплатаКадры.НастройкиПечатныхФорм()
//
Функция НастройкиПечатныхФорм() Экспорт
	
	НастройкиПечатныхФорм = РегистрыСведений.ДополнительныеНастройкиЗарплатаКадры.НастройкиПечатныхФорм();
	Возврат Новый ФиксированнаяСтруктура(НастройкиПечатныхФорм);
	
КонецФункции

// Возвращает коллекцию элементов справочника ВидыКонтактнойИнформации с типом Адрес.
//
Функция ВидыРоссийскихАдресов() Экспорт
	
	РоссийскиеАдреса = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВидыКонтактнойИнформации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
		|ГДЕ
		|	ВидыКонтактнойИнформации.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
		|	И ВидыКонтактнойИнформации.ТолькоНациональныйАдрес";
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		РоссийскиеАдреса.Вставить(Выборка.Ссылка, Истина);
	КонецЦикла; 
	
	Возврат РоссийскиеАдреса;
	
КонецФункции

// Получает размер минимальной оплаты труда.
//
// Параметры:
//	ДатаАктуальности - дата, на которую нужно получить МРОТ.
//
// Возвращаемое значение:
//	число, размер МРОТ на дату, или Неопределено, если МРОТ на дату не определен.
//
Функция МинимальныйРазмерОплатыТрудаРФ(ДатаАктуальности) Экспорт
	
	Возврат РегистрыСведений.МинимальнаяОплатаТрудаРФ.ДанныеМинимальногоРазмераОплатыТрудаРФ(ДатаАктуальности)["Размер"];
	
КонецФункции	

Функция МаксимальныйПриоритетСостоянийСотрудника() Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Увольнение", Перечисления.СостоянияСотрудника.Увольнение);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияСотрудника.Порядок
	|ИЗ
	|	Перечисление.СостоянияСотрудника КАК СостоянияСотрудника
	|ГДЕ
	|	СостоянияСотрудника.Ссылка = &Увольнение";	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	Возврат Выборка.Порядок;
КонецФункции	

// Проверяет принадлежность объекта метаданных к подсистемам. Проверка производится на вхождение
// в состав указанных подсистем и на вхождение в состав подсистем подчиненных указанным.
//
// Параметры:
//			ПолноеИмяОбъектаМетаданных 	- Строка, полное имя объекта метаданных (см. функцию НайтиПоПолномуИмени).
//			ИменаПодсистем				- Строка, имена подсистем, перечисленные через запятую.
//
// Возвращаемое значение:
//		Булево
//
Функция ОбъектМетаданныхВключенВПодсистемы(ПолноеИмяОбъектаМетаданных, ИменаПодсистем) Экспорт
	
	ЭтоОбъектПодсистемы = Ложь;
	
	МассивИменПодсистем = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаПодсистем);
	Для каждого ИмяПодсистемы Из МассивИменПодсистем Цикл
		
		МетаданныеПодсистемы = Метаданные.Подсистемы.Найти(ИмяПодсистемы);
		Если МетаданныеПодсистемы <> Неопределено Тогда
			ЭтоОбъектПодсистемы = ОбъектМетаданныхВключенВПодсистему(МетаданныеПодсистемы, ПолноеИмяОбъектаМетаданных);
		КонецЕсли;
		
		Если ЭтоОбъектПодсистемы Тогда
			Прервать;
		КонецЕсли; 
		
	КонецЦикла;
	
	Возврат ЭтоОбъектПодсистемы;
	
КонецФункции

// Проверяет вхождение объекта метаданных в подсистему. Рекурсивно проверяется вхождение
// объекта метаданных в подсистемы подчиненные указанной.
//
// Параметры:
//		МетаданныеПодсистемы	- Метаданные подсистемы.
//		МетаданныеОбъекта		- Метаданные объекта.
//
// Возвращаемое значение:
//		Булево
//
Функция ОбъектМетаданныхВключенВПодсистему(МетаданныеПодсистемы, ПолноеИмяОбъектаМетаданных)
	
	Возврат ЗарплатаКадрыПовтИсп.ОбъектыМетаданныхПодсистемы(МетаданныеПодсистемы.ПолноеИмя()).Получить(ПолноеИмяОбъектаМетаданных) = Истина;
	
КонецФункции

Функция ОбъектыМетаданныхПодсистемы(ПолноеИмяОбъектаМетаданныхПодсистемы) Экспорт
	
	СоставОбъектов = Новый Соответствие;
	ЗаполнитьОбъектыПодсистемы(Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданныхПодсистемы), СоставОбъектов);
	
	Возврат СоставОбъектов;
	
КонецФункции

Процедура ЗаполнитьОбъектыПодсистемы(МетаданныеПодсистемы, КоллекцияИменОбъектов)
	
	Для Каждого ОбъектСостава Из МетаданныеПодсистемы.Состав Цикл
		
		Если ОбъектСостава <> Неопределено Тогда
			КоллекцияИменОбъектов.Вставить(ОбъектСостава.ПолноеИмя(), Истина);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого МетаданныеПодчиненнойПодсистемы Из МетаданныеПодсистемы.Подсистемы Цикл
		ЗаполнитьОбъектыПодсистемы(МетаданныеПодчиненнойПодсистемы, КоллекцияИменОбъектов);
	КонецЦикла;
	
КонецПроцедуры

// Строит соответствие тарифов страховых взносов на ОПС по категориям застрахованных лиц. 
//
// Параметры:
//  ОтчетныйГод - Число - год, для которого следует определить тариф;
//
// Возвращаемое значение:
//  Соответствие, ключом которого является категория ЗЛ (ПеречислениеСсылка.КатегорииЗастрахованныхЛицДляПФР), 
//					а значением - структура с полями ПФРСтраховая и ПФРНакопительная.
//
Функция ТарифыВзносовПоКатегориямЗЛ(ОтчетныйГод) Экспорт

	Возврат ПерсонифицированныйУчет.ТарифыПоКатегориям(Дата(ОтчетныйГод, 1, 1))

КонецФункции 

// Строит соответствие кодов тарифов страховых взносов на ОПС кодам категорий застрахованных лиц. 
//
// Параметры:
//  ОтчетныйГод - Число - год, для которого следует определить тариф;
//
// Возвращаемое значение:
//  Соответствие, ключом которого является код категории ЗЛ (строка), а значением - код тарифа (строка).
//
Функция СоответствиеКодовТарифаКодамКатегорийЗастрахованных(ОтчетныйГод) Экспорт
	Возврат ПерсонифицированныйУчет.СоответствиеКодовТарифаКодамКатегорийЗастрахованных(ОтчетныйГод)
КонецФункции

Функция ДоступныеОрганизации() Экспорт
	
	ДоступныеОбъекты = Новый Структура("Организации,Филиалы");
	ДоступныеОбъекты.Филиалы = УправлениеДоступом.РазрешенныеЗначенияДляДинамическогоСписка(
		"Справочник.Организации", Тип("СправочникСсылка.Организации"));
	
	ДоступныеОбъекты.Организации = ОрганизацииФилиалов(ДоступныеОбъекты.Филиалы);
	
	Возврат ДоступныеОбъекты;
	
КонецФункции

Функция ОрганизацииФилиалов(Филиалы)
	
	Если ЗначениеЗаполнено(Филиалы) Тогда
		
		ЗапросПоОрганизациям = Новый Запрос;
		ЗапросПоОрганизациям.УстановитьПараметр("РазрешенныеФилиалы", Филиалы);
		
		ЗапросПоОрганизациям.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Организации.ГоловнаяОрганизация КАК ГоловнаяОрганизация
			|ИЗ
			|	Справочник.Организации КАК Организации
			|ГДЕ
			|	Организации.Ссылка В(&РазрешенныеФилиалы)";
		
		УстановитьПривилегированныйРежим(Истина);
		Организации = ЗапросПоОрганизациям.Выполнить().Выгрузить().ВыгрузитьКолонку("ГоловнаяОрганизация");
		УстановитьПривилегированныйРежим(Ложь);
		
	Иначе
		Организации = Новый Массив;
	КонецЕсли;
	
	Возврат Организации;
	
КонецФункции

Функция ИмяКлиентскогоПриложения() Экспорт
	
	ИмяПриложения = "1C Enterprise 8.3";
	
	СтандартнаяОбработка = Истина;
	
	ЗарплатаКадрыПереопределяемый.ПриОпределенииИмениКлиентскогоПриложения(ИмяПриложения, СтандартнаяОбработка);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КонфигурацииЗарплатаКадры") Тогда
		МодульКонфигурацииЗарплатаКадры = ОбщегоНазначения.ОбщийМодуль("КонфигурацииЗарплатаКадры");
		МодульКонфигурацииЗарплатаКадры.ПриОпределенииИмениКлиентскогоПриложения(ИмяПриложения, СтандартнаяОбработка);
	КонецЕсли;
	
	Возврат ИмяПриложения;
	
КонецФункции

// Формирует соответствие статей расходов способам расчетов с физическими лицами.
//
//	Возвращаемое значение: Соответствие
//		Ключ 		- ПеречислениеСсылка.СпособыРасчетовСФизическимиЛицами
//		Значение 	- СправочникаСсылка.СтатьиРасходовЗарплата
//
Функция СтатьиРасходовПоСпособамРасчетовСФизическимиЛицами() Экспорт

	СоответствиеСпособовРасчетов = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(СтатьиРасходовЗарплата.Ссылка, ЗНАЧЕНИЕ(Справочник.СтатьиРасходовЗарплата.ПустаяСсылка)) КАК Ссылка,
	|	СпособыРасчетовСФизическимиЛицами.Ссылка КАК СпособРасчетов
	|ИЗ
	|	Перечисление.СпособыРасчетовСФизическимиЛицами КАК СпособыРасчетовСФизическимиЛицами
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтатьиРасходовЗарплата КАК СтатьиРасходовЗарплата
	|		ПО СпособыРасчетовСФизическимиЛицами.Ссылка = СтатьиРасходовЗарплата.СпособРасчетовСФизическимиЛицами
	|ГДЕ
	|	СтатьиРасходовЗарплата.СпособРасчетовСФизическимиЛицами <> ЗНАЧЕНИЕ(Перечисление.СпособыРасчетовСФизическимиЛицами.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СоответствиеСпособовРасчетов.Вставить(Выборка.СпособРасчетов, Выборка.Ссылка);
	КонецЦикла;
	
	Возврат СоответствиеСпособовРасчетов;

КонецФункции

Функция УОрганизацииЕстьФилиалы(Знач Организация) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЕстьФилиалы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЕстьОбособленныеПодразделения");
	
	Если ЕстьФилиалы Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ГоловнаяОрганизация", Организация);
		
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА КАК ЕстьФилиал
			|ИЗ
			|	Справочник.Организации КАК Организации
			|ГДЕ
			|	Организации.ГоловнаяОрганизация = &ГоловнаяОрганизация
			|	И Организации.Ссылка <> &ГоловнаяОрганизация";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			ЕстьФилиалы = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ЕстьФилиалы;
	
КонецФункции

Функция ОбъектыЗарплатноКадровойБиблиотекиСДополнительнымиСвойствами() Экспорт
	
	ОбъектыСоСвойствами = Новый Соответствие;
	ИменаПредопределенных = Метаданные.Справочники.НаборыДополнительныхРеквизитовИСведений.ПолучитьИменаПредопределенных();
	
	КоллекцииОбъектов = Новый Структура;
	КоллекцииОбъектов.Вставить("Справочник", Метаданные.Справочники);
	КоллекцииОбъектов.Вставить("Документ", Метаданные.Документы);
	КоллекцииОбъектов.Вставить("ПланВидовРасчета", Метаданные.ПланыВидовРасчета);
	
	Для Каждого ОписаниеКоллекции Из КоллекцииОбъектов Цикл
		
		Для Каждого МетаданныеОбъекта Из ОписаниеКоллекции.Значение Цикл
			
			ПолноеИмяОбъектаМетаданных = МетаданныеОбъекта.ПолноеИмя();
			Если Не ЗарплатаКадры.ЭтоОбъектЗарплатноКадровойБиблиотеки(ПолноеИмяОбъектаМетаданных) Тогда
				Продолжить;
			КонецЕсли; 
			
			ИмяНабораСвойств = ОписаниеКоллекции.Ключ + "_" + МетаданныеОбъекта.Имя;
			Если ИменаПредопределенных.Найти(ИмяНабораСвойств) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ОбъектыСоСвойствами.Вставить(ПолноеИмяОбъектаМетаданных, ИмяНабораСвойств);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ОбъектыСоСвойствами;
	
КонецФункции

// Возвращает соответствие у которого Ключ содержит полное имя объекта метаданных,
// управляющего функциональными опциями, а значение- Массив полных имен метаданных
// функциональных опций которыми он управляет.
//
Функция ОбъектыУправляющиеФункциональнымиОпциями() Экспорт
	
	ОбъектыУправляющиеОпциями = Новый Соответствие;
	
	Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
		
		Если Не ЗарплатаКадры.ЭтоОбъектЗарплатноКадровойБиблиотеки(ФункциональнаяОпция.ПолноеИмя()) Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяХранения = ФункциональнаяОпция.Хранение.ПолноеИмя();
		Если СтрЧислоВхождений(ИмяХранения, ".") > 1 Тогда
			ИмяХранения = Лев(ИмяХранения, СтрНайти(ИмяХранения, ".", , , 2) - 1);
		КонецЕсли;
		
		КоллекцияОпций = ОбъектыУправляющиеОпциями.Получить(ИмяХранения);
		Если КоллекцияОпций = Неопределено Тогда
			КоллекцияОпций = Новый Массив;
		КонецЕсли;
		
		КоллекцияОпций.Добавить(ФункциональнаяОпция.ПолноеИмя());
		ОбъектыУправляющиеОпциями.Вставить(ИмяХранения, КоллекцияОпций);
		
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(ОбъектыУправляющиеОпциями);
	
КонецФункции

// Возвращает соответствие с описанием объекта метаданных с дополнительными
// реквизитами (свойствами), управляемых значениями функциональных опций.
//
// Параметры:
//	ПолноеИмяФункциональнойОпции	- Строка, полное имя объектов метаданных
//										функциональная опция
//
// Возвращаемое значение:
//	Соответствие	-	*Ключ		- полное имя объекта метаданных
//						*Значение	- Имя предопределенной группы справочника
//										НаборыДополнительныхРеквизитовИСведений
//
Функция ОбъектыСДополнительнымиСвойствамиУправляемыеФункциональнымиОпциями(ПолноеИмяФункциональнойОпции) Экспорт
	
	ОбъектыЗарплатноКадровойБиблиотеки = ЗарплатаКадрыПовтИсп.ОбъектыЗарплатноКадровойБиблиотекиСДополнительнымиСвойствами();
	ОбъектыОпции = Новый Соответствие;
	
	ФункциональнаяОпция = Метаданные.НайтиПоПолномуИмени(ПолноеИмяФункциональнойОпции);
	Для Каждого Элемент Из ФункциональнаяОпция.Состав Цикл
		
		Если Элемент.Объект <> Неопределено Тогда
			
			ПолноеИмяОбъекта = Элемент.Объект.ПолноеИмя();
			
			ОписаниеОбъекта = ОбъектыЗарплатноКадровойБиблиотеки.Получить(ПолноеИмяОбъекта);
			Если ОписаниеОбъекта <> Неопределено Тогда
				ОбъектыОпции.Вставить(ПолноеИмяОбъекта, ОписаниеОбъекта);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ОбъектыОпции;
	
КонецФункции

// Возвращает соответствие с описанием объекта метаданных с дополнительными
// реквизитами (свойствами) не управляемыми значениями функциональных опций.
//
// Возвращаемое значение:
//	Соответствие	-	*Ключ - полное имя объекта метаданных
//						*Значение - Имя предопределенной группы справочника
//									НаборыДополнительныхРеквизитовИСведений
//
Функция ОбъектыСДополнительнымиСвойствамиНеУправляемыеФункциональнымиОпциями() Экспорт
	
	ОбъектыЗарплатноКадровойБиблиотеки = ЗарплатаКадрыПовтИсп.ОбъектыЗарплатноКадровойБиблиотекиСДополнительнымиСвойствами();
	
	ОбъектыОпций = ОбщегоНазначенияКлиентСервер.СкопироватьСоответствие(ОбъектыЗарплатноКадровойБиблиотеки);
	Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
		
		Для Каждого Элемент Из ФункциональнаяОпция.Состав Цикл
			
			Если Элемент.Объект <> Неопределено Тогда
				ОбъектыОпций.Удалить(Элемент.Объект.ПолноеИмя());
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ОбъектыОпций;
	
КонецФункции

Функция ОбъектыУправляемыеНесколькимиФункциональнымиОпциями() Экспорт
	
	ФункциональныеОпцииОбъектов = Новый Соответствие;
	ОбъектыКУдалению = Новый Соответствие;
	Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
		
		Если Не ЗарплатаКадры.ЭтоОбъектЗарплатноКадровойБиблиотеки(ФункциональнаяОпция.ПолноеИмя()) Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ОбъектСостава Из ФункциональнаяОпция.Состав Цикл
			
			Если ОбъектСостава.Объект = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ИмяОбъекта = ОбъектСостава.Объект.ПолноеИмя();
			Если СтрЧислоВхождений(ИмяОбъекта, ".") > 1 Тогда
				Продолжить;
			КонецЕсли;
			
			Если Не СтрНачинаетсяС(ИмяОбъекта, "Справочник.")
				И Не СтрНачинаетсяС(ИмяОбъекта, "Документ.") Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			ФункциональныеОпцииОбъекта = ФункциональныеОпцииОбъектов.Получить(ИмяОбъекта);
			Если ФункциональныеОпцииОбъекта = Неопределено Тогда
				ФункциональныеОпцииОбъекта = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФункциональнаяОпция.ПолноеИмя());
				ОбъектыКУдалению.Вставить(ИмяОбъекта);
			Иначе
				ФункциональныеОпцииОбъекта.Добавить(ФункциональнаяОпция.ПолноеИмя());
				ОбъектыКУдалению.Удалить(ИмяОбъекта);
			КонецЕсли;
			
			ФункциональныеОпцииОбъектов.Вставить(ИмяОбъекта, ФункциональныеОпцииОбъекта);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Для Каждого ОписаниеОбъекта Из ОбъектыКУдалению Цикл
		ФункциональныеОпцииОбъектов.Удалить(ОписаниеОбъекта.Ключ);
	КонецЦикла;
	
	Возврат ФункциональныеОпцииОбъектов;
	
КонецФункции

Функция ОсновнойСотрудникФизическогоЛица(ФизическоеЛицо, Организация, Период) Экспорт
	
	СотрудникиФизическихЛиц = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо), Истина, Организация, Период);
	
	Если СотрудникиФизическихЛиц.Количество() > 0 Тогда
		
		СтрокаСотрудника = СотрудникиФизическихЛиц.Найти(ФизическоеЛицо, "ФизическоеЛицо");
		Если СтрокаСотрудника <> Неопределено Тогда
			Возврат СтрокаСотрудника.Сотрудник;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти
