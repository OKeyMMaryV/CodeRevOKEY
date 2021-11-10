﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает строковое представление уведомления о постановке на учет в качестве плательщика
// торгового сбора.
//
// Параметры:
//  Уведомление - ДокументСсылка.УведомленияОСпецрежимахНалогообложения - ссылка на уведомление.
//
// Возвращаемое значение:
//  Строка - представление уведомления.
//
Функция ПредставлениеУведомления(Уведомление) Экспорт
	
	Результат = "";
	
	Если НЕ ЗначениеЗаполнено(Уведомление) Тогда
		Возврат Результат;
	КонецЕсли;
	
	// БРО может поменять структуру данных уведомлений.
	Попытка
		
		ДанныеУведомления = Уведомление.ДанныеУведомления.Получить();
		
		Если Уведомление.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1 Тогда
			КодПричины = ДанныеУведомления.Титульный[0].КодПричины;
			
			Если КодПричины = "1" Тогда
				Представление = НСтр("ru='О постановке на учет в ИФНС %1'");
				
			ИначеЕсли КодПричины = "2" Тогда
				Представление = НСтр("ru='Об изменении параметров в ИФНС %1'");
				
			Иначе
				Представление = НСтр("ru='О снятии с учета в ИФНС %1'");
				
			КонецЕсли;
			
			Результат = СтрШаблон(Представление, ДанныеУведомления.Титульный[0].КОД_НО);
			
		ИначеЕсли Уведомление.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС2 Тогда
			Представление = НСтр("ru='О снятии с учета в ИФНС %1'");
			Результат = СтрШаблон(Представление, ДанныеУведомления.Титульный[0].КОД_НО);
			
		Иначе
			Результат = Строка(Уведомление);
			
		КонецЕсли;
		
	Исключение
		Результат = Строка(Уведомление);
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Возвращает код льготы по наименованию.
//
// Параметры:
//  Льготы - ТаблицаЗначений - см. ТорговыйСбор.ПрочитатьТаблицуЛьгот().
//  НаименованиеЛьготы - Строка - Наименование льготы из поставляемых данных
//                                РегистрСведений.ПараметрыТорговыхТочек.Макеты.Льготы.
//  ТипТорговойТочки - ПеречислениеСсылка.ТипыТорговыхТочек - Тип торговой точки.
//
// Возвращаемое значение:
//  Строка - код налоговой льготы.
//
Функция КодЛьготыПоНаименованию(Льготы, НаименованиеЛьготы, ТипТорговойТочки) Экспорт
	
	Отбор = Новый Структура("Наименование, ТипТорговойТочки", НаименованиеЛьготы, ТипТорговойТочки);
	ПредставлениеЛьготы = Льготы.НайтиСтроки(Отбор);
	
	Если ПредставлениеЛьготы.Количество() = 1 Тогда
		Возврат ПредставлениеЛьготы[0].КодНалоговойЛьготы;
		
	Иначе
		// Код налоговой льготы "Не применяется".
		Возврат "000000000000";
		
	КонецЕсли;
	
КонецФункции

// Возвращает наименование налоговой льготы по коду.
//
// Параметры:
//  Льготы - ТаблицаЗначений - см. ТорговыйСбор.ПрочитатьТаблицуЛьгот().
//  КодНалоговойЛьготы - Строка - Код налоговой льготы.
//  ТипТорговойТочки - ПеречислениеСсылка.ТипыТорговыхТочек - Тип торговой точки.
//
// Возвращаемое значение:
//  Строка - Наименование льготы из поставляемых данных
//           РегистрСведений.ПараметрыТорговыхТочек.Макеты.Льготы.
//
Функция НаименованиеПоКодуЛьготы(Льготы, КодНалоговойЛьготы, ТипТорговойТочки) Экспорт
	
	Отбор = Новый Структура("КодНалоговойЛьготы, ТипТорговойТочки", КодНалоговойЛьготы, ТипТорговойТочки);
	ПредставлениеЛьготы = Льготы.НайтиСтроки(Отбор);
	
	Если ПредставлениеЛьготы.Количество() = 1 Тогда
		Возврат ПредставлениеЛьготы[0].Наименование;
		
	Иначе
		Возврат НСтр("ru='Не применяется'");
		
	КонецЕсли;
	
КонецФункции

// Расчет суммы уплачиваемого торгового сбора по торговой точке. Результат расчета сохраняется в 
// ПараметрыТорговойТочки.
//
// Параметры:
//  ПараметрыТорговойТочки - РегистрСведенийМенеджерЗаписи.ПараметрыТорговыхТочек - Параметры торговой точки.
//  СтавкиСбора - ТаблицаЗначений - см. ТорговыйСбор.ПрочитатьТаблицуСтавок().
//  Территории  - ТаблицаЗначений - см. ТорговыйСбор.ПрочитатьТаблицуТерриторий().
//
Процедура РассчитатьСуммуСбора(ПараметрыТорговойТочки, СтавкиСбора, Территории) Экспорт
	
	Если НЕ ДанныеДляРасчетаСтавкиУказаны(ПараметрыТорговойТочки) Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("КодПоОКТМО", СокрЛП(ПараметрыТорговойТочки.КодПоОКТМО));
	Если ТипЗнч(Территории) = Тип("ТаблицаЗначений") Тогда
		ТаблицаТерриторий = Территории.Скопировать(Отбор, "Территория");
	Иначе
		ТаблицаТерриторий = Территории.Выгрузить(Отбор, "Территория");
	КонецЕсли;
	
	Если ТаблицаТерриторий.Количество() = 0 Тогда
		Территория = Справочники.ТерриторииОсуществленияТорговойДеятельности.ПустаяСсылка();
	Иначе
		Территория = ТаблицаТерриторий[0].Территория;
	КонецЕсли;
	
	Отбор = Новый Структура("Территория, ВидТорговойДеятельности", Территория, ПараметрыТорговойТочки.ВидТорговойДеятельности);
	
	Если ТипЗнч(СтавкиСбора) = Тип("ТаблицаЗначений") Тогда
		ТаблицаСтавок = СтавкиСбора.Скопировать(Отбор);
	Иначе
		ТаблицаСтавок = СтавкиСбора.Выгрузить(Отбор);
	КонецЕсли;
	
	ЕстьТорговыйЗал = ЕстьТорговыйЗал(ПараметрыТорговойТочки.ТипТорговойТочки);
	
	СтавкаСбораНайдена = Ложь;
	Для Каждого СтавкаСбора Из ТаблицаСтавок Цикл
		ТорговаяТочкаПериод  = НачалоДня(ПараметрыТорговойТочки.Период);
		ПлощадьТорговогоЗала = ПараметрыТорговойТочки.ПлощадьТорговогоЗала;
		
		Если (СтавкаСбора.ДействуетС <= ТорговаяТочкаПериод И ТорговаяТочкаПериод <= СтавкаСбора.ДействуетПо)
			И (НЕ ЕстьТорговыйЗал 
				ИЛИ (СтавкаСбора.НижняяГраница < ПлощадьТорговогоЗала И  ПлощадьТорговогоЗала <= СтавкаСбора.ВерхняяГраница)) Тогда
			
			СтавкаСбораНайдена = Истина;
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ СтавкаСбораНайдена Тогда
		ПараметрыТорговойТочки.СуммаСбора         = 0;
		ПараметрыТорговойТочки.Ставка             = 0;
		ПараметрыТорговойТочки.СуммаЛьготы        = 0;
		ПараметрыТорговойТочки.РасшифровкаРасчета = НСтр("ru='Не удалось автоматически рассчитать ставку на основании введенных данных о торговой точке.
			|Возможно, допущена ошибка в адресе или коде ОКТМО. Проверьте указанные данные или укажите сумму уплачиваемого сбора самостоятельно.'");
		Возврат;
	КонецЕсли;
	
	Если ПараметрыТорговойТочки.ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.РозничныйРынок Тогда
		ПараметрыТорговойТочки.СуммаСбора = СтавкаСбора.Превышение * ПараметрыТорговойТочки.ПлощадьТорговогоЗала;
		ПараметрыТорговойТочки.Ставка = ПараметрыТорговойТочки.СуммаСбора;
		
	Иначе
		Если ЕстьТорговыйЗал И СтавкаСбора.Превышение > 0 Тогда
			// Если ставка сложная (базовая + превышение), то для уведомления используем расчетную ставку за кв.м.
			СтавкаЗаМетр = РасчетнаяСтавкаЗаМетр(ПараметрыТорговойТочки, СтавкаСбора);
			ПараметрыТорговойТочки.Ставка = СтавкаЗаМетр * ПараметрыТорговойТочки.ПлощадьТорговогоЗала;
		Иначе
			ПараметрыТорговойТочки.Ставка = СтавкаСбора.БазоваяСтавка;
		КонецЕсли;
		
		Если ПрименяетсяЛьгота(ПараметрыТорговойТочки.КодНалоговойЛьготы) Тогда
			// применение льготы освобождает от уплаты торгового сбора
			ПараметрыТорговойТочки.СуммаСбора = 0;
			ПараметрыТорговойТочки.СуммаЛьготы = ПараметрыТорговойТочки.Ставка;
			
		Иначе
			ПараметрыТорговойТочки.СуммаСбора = ПараметрыТорговойТочки.Ставка;
			ПараметрыТорговойТочки.СуммаЛьготы = 0;
		КонецЕсли;
	КонецЕсли;
	
	СоздатьРасшифровкуРасчетаСуммыСбора(ПараметрыТорговойТочки, СтавкаСбора);
	
КонецПроцедуры

// Возвращает значение параметров торговой точки на дату.
//
// Параметры:
//  ТорговаяТочка - СправочникСсылка.ТорговыеТочки - Торговая точка.
//  НаДату        - Дата - Дата на которую будут получены параметры торговой точки.
//
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса - значение параметров торговой точки.
//
Функция ПараметрыТорговойТочки(ТорговаяТочка, НаДату) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НаДату"       , НаДату);
	Запрос.УстановитьПараметр("ТорговаяТочка", ТорговаяТочка);
	Запрос.УстановитьПараметр("Организация"  , ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТорговаяТочка, "Организация"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПараметрыТорговыхТочекСрезПоследних.Период,
	|	ПараметрыТорговыхТочекСрезПоследних.Организация,
	|	ПараметрыТорговыхТочекСрезПоследних.ТорговаяТочка,
	|	ПараметрыТорговыхТочекСрезПоследних.ПодразделениеОрганизации,
	|	ПараметрыТорговыхТочекСрезПоследних.КодПоОКТМО,
	|	ПараметрыТорговыхТочекСрезПоследних.ВидТорговойДеятельности,
	|	ПараметрыТорговыхТочекСрезПоследних.ОснованиеПользования,
	|	ПараметрыТорговыхТочекСрезПоследних.ПостановкаНаУчетВНалоговомОргане,
	|	ПараметрыТорговыхТочекСрезПоследних.НалоговыйОрган,
	|	ПараметрыТорговыхТочекСрезПоследних.ВидОбъектаНедвижимости,
	|	ПараметрыТорговыхТочекСрезПоследних.КадастровыйНомер,
	|	ПараметрыТорговыхТочекСрезПоследних.НомерРазрешения,
	|	ПараметрыТорговыхТочекСрезПоследних.ПлощадьТорговогоЗала,
	|	ПараметрыТорговыхТочекСрезПоследних.КодНалоговойЛьготы,
	|	ПараметрыТорговыхТочекСрезПоследних.Ставка,
	|	ПараметрыТорговыхТочекСрезПоследних.СуммаЛьготы,
	|	ПараметрыТорговыхТочекСрезПоследних.СуммаСбора,
	|	ПараметрыТорговыхТочекСрезПоследних.РасшифровкаРасчета,
	|	ПараметрыТорговыхТочекСрезПоследних.ТипТорговойТочки,
	|	ПараметрыТорговыхТочекСрезПоследних.ВидОперации
	|ИЗ
	|	РегистрСведений.ПараметрыТорговыхТочек.СрезПоследних(
	|			&НаДату,
	|			ТорговаяТочка = &ТорговаяТочка
	|				И Организация = &Организация) КАК ПараметрыТорговыхТочекСрезПоследних";
	
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Возврат Результат;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает дату запрета изменения.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - Организация для которой будет получена дата запрета изменения.
//
// Возвращаемое значение:
//  Дата - Дата запрета изменения.
//
Функция ДатаЗапретаИзменения(Организация) Экспорт
	
	Результат = '00010101';
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДатыЗапретаИзменения") Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Дата запрета изменения определяется со следующими приоритетами (от высшего к низшему):
	// 1. Дата запрета установленная для пользователя, раздела и объекта;
	// 2. Дата установленная для всех пользователей раздела и объекта;
	// 3. Дата установленная для пользователя по всем разделам и объектам;
	// 4. Дата установленная для всех пользователей всех разделов и объектов.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("ТекущаяДата" , ОбщегоНазначения.ТекущаяДатаПользователя());
	Запрос.УстановитьПараметр("Объект"      , Организация);
	Запрос.УстановитьПараметр("РазделБухгалтерскийУчет", ДатыЗапретаИзмененияБП.РазделБухгалтерскийУчет().Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МАКСИМУМ(ДатыЗапретаИзменения.ДатаЗапрета) КАК ДатаЗапрета
	|ИЗ
	|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|ГДЕ
	|	ДатыЗапретаИзменения.ДатаЗапрета <= &ТекущаяДата
	|	И ДатыЗапретаИзменения.Пользователь = &Пользователь
	|	И ДатыЗапретаИзменения.Объект = &Объект
	|	И ДатыЗапретаИзменения.Раздел = &РазделБухгалтерскийУчет
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МАКСИМУМ(ДатыЗапретаИзменения.ДатаЗапрета)
	|ИЗ
	|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|ГДЕ
	|	ДатыЗапретаИзменения.ДатаЗапрета <= &ТекущаяДата
	|	И ДатыЗапретаИзменения.Раздел = &РазделБухгалтерскийУчет
	|	И ДатыЗапретаИзменения.Объект = &Объект
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МАКСИМУМ(ДатыЗапретаИзменения.ДатаЗапрета)
	|ИЗ
	|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|ГДЕ
	|	ДатыЗапретаИзменения.ДатаЗапрета <= &ТекущаяДата
	|	И ДатыЗапретаИзменения.Пользователь = &Пользователь
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МАКСИМУМ(ДатыЗапретаИзменения.ДатаЗапрета)
	|ИЗ
	|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|ГДЕ
	|	ДатыЗапретаИзменения.ДатаЗапрета <= &ТекущаяДата
	|	И ДатыЗапретаИзменения.Пользователь = ЗНАЧЕНИЕ(Перечисление.ВидыНазначенияДатЗапрета.ДляВсехПользователей)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.ДатаЗапрета) Тогда
			Возврат Выборка.ДатаЗапрета;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЕстьТорговыйЗал(ТипТорговойТочки)
	
	Результат = Ложь;
	
	Если ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.Магазин
		ИЛИ ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.Павильон
		ИЛИ ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.ПрочееСТорговымЗалом
		ИЛИ ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.РозничныйРынок Тогда
		
		Результат = Истина;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПревышениеБазовойПлощади(ПлощадьЗала, БазоваяПлощадь)
	Если БазоваяПлощадь = 0 Тогда
		Возврат 0;
	КонецЕсли; 
	
	ПлощадьЗалаСвышеБазовой = ПлощадьЗала - БазоваяПлощадь;
	
	Если ПлощадьЗалаСвышеБазовой < 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	ЦелаяЧасть = Цел(ПлощадьЗалаСвышеБазовой);
	
	Если ПлощадьЗалаСвышеБазовой - ЦелаяЧасть > 0 Тогда
		ПлощадьЗалаСвышеБазовой = ЦелаяЧасть + 1;
	КонецЕсли;
	
	Возврат ПлощадьЗалаСвышеБазовой;
	
КонецФункции

Функция ПрименяетсяЛьгота(КодНалоговойЛьготы)
	
	Возврат ЗначениеЗаполнено(Число(КодНалоговойЛьготы));
	
КонецФункции

Функция ДанныеДляРасчетаСтавкиУказаны(ПараметрыТорговойТочки)
	
	Если ЗначениеЗаполнено(ПараметрыТорговойТочки.ТипТорговойТочки)
		И ЗначениеЗаполнено(ПараметрыТорговойТочки.Период)
		И ЗначениеЗаполнено(ПараметрыТорговойТочки.КодПоОКТМО) Тогда
		
		Результат = Истина;
		
	Иначе
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура СоздатьРасшифровкуРасчетаСуммыСбора(ПараметрыТорговойТочки, СтавкаСбора)
	
	Если ПараметрыТорговойТочки.ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.ТорговыйАвтомат Тогда
		РасшифровкаРасчета = НСтр("ru='Торговля, осуществляемая с использованием вендинговых автоматов, не облагается сбором.'");
		
	ИначеЕсли ПрименяетсяЛьгота(ПараметрыТорговойТочки.КодНалоговойЛьготы) Тогда
		РасшифровкаРасчета = НСтр("ru='В случае применения льготы торговый сбор не уплачивается.'");
		
	ИначеЕсли ПараметрыТорговойТочки.ВидТорговойДеятельности =
		Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.РазвознаяРазноснаяТорговля Тогда
		
		РасшифровкаРасчета = НСтр("ru='Размер торгового сбора для развозной (разносной) торговли фиксирован и составляет %1 руб.'");
		РасшифровкаРасчета = СтрШаблон(РасшифровкаРасчета, ПараметрыТорговойТочки.Ставка);
		
	ИначеЕсли ПараметрыТорговойТочки.ВидТорговойДеятельности =
		Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.СтационарныеСетиСТорговымиЗалами
		И ПараметрыТорговойТочки.ПлощадьТорговогоЗала > 50 Тогда
		
		РасшифровкаРасчета = НСтр("ru='Торговый сбор = Расчетная ставка за кв.м. * Площадь торгового зала
			| Расчетная ставка за кв.м. = (Ставка за %9 кв.м. + (Площадь свыше %9 кв.м. * Ставка за полный кв.м. свыше %9 кв.м)) / Площадь торгового зала
			| Расчетная ставка за кв.м. = (%1 руб. + (%2 кв.м. * %3 руб.)) / %4 кв.м. = %5 руб.
			| Торговый сбор = %6 руб * %7 кв.м. = %8 руб.'");
		РасчетнаяСтавкаЗаМетр = РасчетнаяСтавкаЗаМетр(ПараметрыТорговойТочки, СтавкаСбора);
		РасшифровкаРасчета = СтрШаблон(РасшифровкаРасчета,
			СтавкаСбора.БазоваяСтавка,
			ПревышениеБазовойПлощади(ПараметрыТорговойТочки.ПлощадьТорговогоЗала, СтавкаСбора.НижняяГраница),
			СтавкаСбора.Превышение,
			ПараметрыТорговойТочки.ПлощадьТорговогоЗала,
			РасчетнаяСтавкаЗаМетр,
			РасчетнаяСтавкаЗаМетр,
			ПараметрыТорговойТочки.ПлощадьТорговогоЗала,
			ПараметрыТорговойТочки.Ставка,
			СтавкаСбора.НижняяГраница);
			
	ИначеЕсли ПараметрыТорговойТочки.ВидТорговойДеятельности =
		Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.СтационарныеСетиСТорговымиЗалами
		И СтавкаСбора.НижняяГраница = 0  Тогда
		
		РасшифровкаРасчета = НСтр("ru='Размер торгового сбора для торговых точек с площадью торгового зала менее %2 кв.м
			|фиксирован и составляет %1 руб.'");
		РасшифровкаРасчета = СтрШаблон(РасшифровкаРасчета, ПараметрыТорговойТочки.Ставка, СтавкаСбора.ВерхняяГраница);
		
	ИначеЕсли ПараметрыТорговойТочки.ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.РозничныйРынок Тогда
		РасшифровкаРасчета = НСтр("ru='Торговый сбор = Площадь рынка * Ставка
			|%1 кв.м. * %2 руб. = %3 руб.'");
			
		РасшифровкаРасчета = СтрШаблон(РасшифровкаРасчета,
			ПараметрыТорговойТочки.ПлощадьТорговогоЗала,
			СтавкаСбора.Превышение,
			ПараметрыТорговойТочки.Ставка);
			
	Иначе
		РасшифровкаРасчета = НСтр("ru='Размер торгового сбора, зависит от адреса торговой точки и составляет %1 руб.'");
		РасшифровкаРасчета = СтрШаблон(РасшифровкаРасчета, ПараметрыТорговойТочки.Ставка);
		
	КонецЕсли;
	
	ПараметрыТорговойТочки.РасшифровкаРасчета = РасшифровкаРасчета;
	
КонецПроцедуры

Функция РасчетнаяСтавкаЗаМетр(ПараметрыТорговойТочки, СтавкаСбора)
	РасчетнаяСтавкаЗаМетр = (СтавкаСбора.БазоваяСтавка + ПревышениеБазовойПлощади(ПараметрыТорговойТочки.ПлощадьТорговогоЗала, СтавкаСбора.НижняяГраница) * СтавкаСбора.Превышение)
		/ ПараметрыТорговойТочки.ПлощадьТорговогоЗала;
	РасчетнаяСтавкаЗаМетр = Окр(РасчетнаяСтавкаЗаМетр, 2);
	
	Возврат РасчетнаяСтавкаЗаМетр
	
КонецФункции

#Область ОбработчикиОбновления

Процедура ОбновитьСтавкиТорговогоСбора() Экспорт
	
	ДатаПроверкиСтавки = Дата(2019, 07, 01);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаПроверкиСтавки", ДатаПроверкиСтавки);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПараметрыТорговыхТочекСрезПоследних.Период КАК Период,
	|	ПараметрыТорговыхТочекСрезПоследних.Организация КАК Организация,
	|	ПараметрыТорговыхТочекСрезПоследних.ТорговаяТочка КАК ТорговаяТочка,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийТорговыеТочки.ИзменениеПараметров) КАК ВидОперации
	|ИЗ
	|	РегистрСведений.ПараметрыТорговыхТочек.СрезПоследних(&ДатаПроверкиСтавки, ) КАК ПараметрыТорговыхТочекСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыТорговыхТочек КАК ПараметрыТорговыхТочекНаДатуСреза
	|		ПО ПараметрыТорговыхТочекСрезПоследних.Организация = ПараметрыТорговыхТочекНаДатуСреза.Организация
	|			И ПараметрыТорговыхТочекСрезПоследних.ТорговаяТочка = ПараметрыТорговыхТочекНаДатуСреза.ТорговаяТочка
	|			И (ПараметрыТорговыхТочекНаДатуСреза.Период = &ДатаПроверкиСтавки)
	|ГДЕ
	|	ПараметрыТорговыхТочекСрезПоследних.ВидОперации <> ЗНАЧЕНИЕ(Перечисление.ВидыОперацийТорговыеТочки.СнятиеСУчета)
	|	И ПараметрыТорговыхТочекСрезПоследних.ВидТорговойДеятельности = ЗНАЧЕНИЕ(Перечисление.ВидыТорговойДеятельностиОблагаемыеСбором.СтационарныеСетиСТорговымиЗалами)
	|	И ПараметрыТорговыхТочекНаДатуСреза.Период ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ПараметрыТорговыхТочек.Период,
	|	ПараметрыТорговыхТочек.Организация,
	|	ПараметрыТорговыхТочек.ТорговаяТочка,
	|	ПараметрыТорговыхТочек.ВидОперации
	|ИЗ
	|	РегистрСведений.ПараметрыТорговыхТочек КАК ПараметрыТорговыхТочек
	|ГДЕ
	|	ПараметрыТорговыхТочек.Период >= &ДатаПроверкиСтавки
	|	И ПараметрыТорговыхТочек.ВидТорговойДеятельности = ЗНАЧЕНИЕ(Перечисление.ВидыТорговойДеятельностиОблагаемыеСбором.СтационарныеСетиСТорговымиЗалами)";
	
	ТаблицаСтавок = ТорговыйСбор.ПрочитатьТаблицуСтавок();
	ТаблицаТерриторий = ТорговыйСбор.ПрочитатьТаблицуТерриторий();
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ИсходныеПараметрыТорговойТочки = РегистрыСведений.ПараметрыТорговыхТочек.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(ИсходныеПараметрыТорговойТочки, Выборка, "Период, Организация, ТорговаяТочка");
		ИсходныеПараметрыТорговойТочки.Прочитать();
		
		НовыеПараметрыТорговойТочки = РегистрыСведений.ПараметрыТорговыхТочек.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(НовыеПараметрыТорговойТочки, ИсходныеПараметрыТорговойТочки);
		
		НовыеПараметрыТорговойТочки.Период      = Макс(ИсходныеПараметрыТорговойТочки.Период, ДатаПроверкиСтавки);
		НовыеПараметрыТорговойТочки.ВидОперации = Выборка.ВидОперации;
		
		РассчитатьСуммуСбора(НовыеПараметрыТорговойТочки, ТаблицаСтавок, ТаблицаТерриторий);
		
		Если НовыеПараметрыТорговойТочки.Ставка <> ИсходныеПараметрыТорговойТочки.Ставка Тогда
			НовыеПараметрыТорговойТочки.Записать(Истина);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
