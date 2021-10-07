﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.НачислениеОценочныхОбязательствПоОтпускам;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

// Сформировать печатные формы
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст
//                           ошибки).
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя
//                           области в которой был выведен объект).
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_СправкаПоОтпускамСотрудника") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм,
						"ПФ_MXL_СправкаПоОтпускамСотрудника", НСтр("ru='Справка по отпускам'"),
						ПечатьСправкаПоОтпускамСотрудника(МассивОбъектов, ОбъектыПечати, ПараметрыПечати), ,);
	КонецЕсли;

КонецПроцедуры

Функция ПечатьСправкаПоОтпускамСотрудника(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.АвтоМасштаб = Истина;
	НомерСтрокиНачало = ДокументРезультат.ВысотаТаблицы + 1;
	
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") 
		И ПараметрыПечати.Свойство("ПериодРегистрации") Тогда
		ДатаОтчета = КонецМесяца(ПараметрыПечати.ПериодРегистрации);
	Иначе
		ДатаОтчета = ТекущаяДатаСеанса();
	КонецЕсли;

	ОтчетСправкаПоОтпускамСотрудника = Отчеты["СправкаПоОтпускам"].Создать();
	ОтчетСправкаПоОтпускамСотрудника.ИнициализироватьОтчет();
	КомпоновщикНастроек = ОтчетСправкаПоОтпускамСотрудника.КомпоновщикНастроек;
	
	Отбор = КомпоновщикНастроек.Настройки.Отбор;
	Отбор.Элементы.Очистить();
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Сотрудник", ВидСравненияКомпоновкиДанных.ВСписке, МассивОбъектов);
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ДатаОстатков = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ДатаОстатков");
	ДатаОстатков.Значение = ДатаОтчета;
	ДатаОстатков.Использование = Истина;
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтчета);
	
	ОтчетСправкаПоОтпускамСотрудника.СкомпоноватьРезультат(ДокументРезультат);
	
	Возврат ДокументРезультат;
	
КонецФункции

#КонецОбласти

Функция ТребуетсяУтверждениеДокументаБухгалтером(Организация = Неопределено) Экспорт
	
	// Подтверждение требуется, если используется обмен с бухгалтерией.
	
	// ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3")
		И Не ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КонфигурацииЗарплатаКадры") Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиЗарплата3Бухгалтерия3");
		Возврат Модуль.ОбменИспользуется(Организация);
		
	КонецЕсли;
	// Конец ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3
	
	Возврат Ложь;
	
КонецФункции

Процедура ЗаполнитьНачислениеОценочныхОбязательствПоОтпускам(ПараметрыЗаполнения, АдресХранилища) Экспорт
	
	ЭтотОбъект = ПараметрыЗаполнения.Объект;
	РезервОтпусков.ЗаполнитьДокументНачислениеОценочныхОбязательствПоОтпускам(ЭтотОбъект);
	
	Результат = Новый Структура("ЗаданиеВыполнено, Объект", Истина, ЭтотОбъект);
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

Процедура ПеречитатьОценочныеОбязательства(ПараметрыЗаполнения, АдресХранилища) Экспорт
	
	ЭтотОбъект = ПараметрыЗаполнения.Объект;
	РезервОтпусков.ПеречитатьОценочныеОбязательства(ЭтотОбъект, Истина);
	
	Результат = Новый Структура("ЗаданиеВыполнено, Объект", Истина, ЭтотОбъект);
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

Процедура ПеречитатьОценочныеОбязательстваПоСотрудникам(ПараметрыЗаполнения, АдресХранилища) Экспорт
	
	ЭтотОбъект = ПараметрыЗаполнения.Объект;
	РезервОтпусков.ПеречитатьОценочныеОбязательства(ЭтотОбъект, Ложь);
	
	Результат = Новый Структура("ЗаданиеВыполнено, Объект, ИмяТаблицы", Истина, ЭтотОбъект, "ОценочныеОбязательстваПоСотрудникам");
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

Процедура ОбновитьОтражениеВУчете(ПараметрыЗаполнения, АдресХранилища) Экспорт
	
	ЭтотОбъект = ПараметрыЗаполнения.Объект;
	РезервОтпусков.ОбновитьОтражениеВУчете(ЭтотОбъект);
	
	Результат = Новый Структура("ЗаданиеВыполнено, Объект, ИмяТаблицы", Истина, ЭтотОбъект, "ОценочныеОбязательства");
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

#КонецОбласти

#КонецЕсли