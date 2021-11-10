﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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

#Область ОбновлениеИнформационнойБазы

Процедура ЗаполнитьДоговорКонтрагентаОтложенно(Параметры) Экспорт

	Запрос = Новый Запрос;
	
	КонецПериодаВыборки = '29991231235959';
	
	Если Параметры.Свойство("КонецПериодаВыборки")
		И ТипЗнч(Параметры.КонецПериодаВыборки) = Тип("Дата") Тогда
		КонецПериодаВыборки = Параметры.КонецПериодаВыборки;
	КонецЕсли;
	
	СсылкаНаПоследнийДокумент = Документы.ДокументРасчетовСКонтрагентом.ПустаяСсылка();
	Если Параметры.Свойство("СсылкаНаПоследнийДокумент") Тогда
		СсылкаНаПоследнийДокумент = Параметры.СсылкаНаПоследнийДокумент;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("КонецПериодаВыборки",       КонецПериодаВыборки);
	Запрос.УстановитьПараметр("СсылкаНаПоследнийДокумент", СсылкаНаПоследнийДокумент);
	
	// Движения документов "Отчет о розничных продажах" не обновляем,
	// их невозможно постфактум разделить по договорам.
	// Такие документы потребуется первый раз перепровести полностью, чтобы правильно разделить строки по договорам.
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиСистемыНалогообложения.Организация КАК Организация,
	|	НастройкиСистемыНалогообложения.Период КАК ДатаНачала,
	|	МИНИМУМ(ДОБАВИТЬКДАТЕ(ЕСТЬNULL(НастройкиСистемыНалогообложенияСледующая.Период, ДАТАВРЕМЯ(2999, 12, 31)), СЕКУНДА, -1)) КАК ДатаОкончания
	|ПОМЕСТИТЬ ВТ_ПериодыУСНДоходы
	|ИЗ
	|	РегистрСведений.НастройкиСистемыНалогообложения КАК НастройкиСистемыНалогообложения
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиСистемыНалогообложения КАК НастройкиСистемыНалогообложенияСледующая
	|		ПО НастройкиСистемыНалогообложения.Организация = НастройкиСистемыНалогообложенияСледующая.Организация
	|			И НастройкиСистемыНалогообложения.Период < НастройкиСистемыНалогообложенияСледующая.Период
	|ГДЕ
	|	НастройкиСистемыНалогообложения.ПрименяетсяУСНДоходы
	|
	|СГРУППИРОВАТЬ ПО
	|	НастройкиСистемыНалогообложения.Организация,
	|	НастройкиСистемыНалогообложения.Период
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ДатаНачала,
	|	ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1000
	|	КнигаУчетаДоходовИРасходов.Регистратор КАК Регистратор,
	|	МИНИМУМ(КнигаУчетаДоходовИРасходов.Период) КАК Период
	|ПОМЕСТИТЬ ВТ_Документы
	|ИЗ
	|	ВТ_ПериодыУСНДоходы КАК ВТ_ПериодыУСНДоходы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.КнигаУчетаДоходовИРасходов КАК КнигаУчетаДоходовИРасходов
	|		ПО ВТ_ПериодыУСНДоходы.Организация = КнигаУчетаДоходовИРасходов.Организация
	|			И (КнигаУчетаДоходовИРасходов.Период МЕЖДУ ВТ_ПериодыУСНДоходы.ДатаНачала И ВТ_ПериодыУСНДоходы.ДатаОкончания)
	|			И (КнигаУчетаДоходовИРасходов.ДоговорКонтрагента = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка))
	|			И (КнигаУчетаДоходовИРасходов.Период < &КонецПериодаВыборки
	|				ИЛИ КнигаУчетаДоходовИРасходов.Период = &КонецПериодаВыборки
	|					И КнигаУчетаДоходовИРасходов.Регистратор < &СсылкаНаПоследнийДокумент)
	|ГДЕ
	|	НЕ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.ОтчетОРозничныхПродажах
	|
	|СГРУППИРОВАТЬ ПО
	|	КнигаУчетаДоходовИРасходов.Регистратор
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ,
	|	Регистратор УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Документы.Регистратор КАК Регистратор,
	|	ВТ_Документы.Период КАК Период,
	|	ХозрасчетныйСубконто.Значение КАК ДоговорКонтрагента
	|ПОМЕСТИТЬ ВТ_ДоговорыПоДокументам
	|ИЗ
	|	ВТ_Документы КАК ВТ_Документы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Субконто КАК ХозрасчетныйСубконто
	|		ПО ВТ_Документы.Регистратор = ХозрасчетныйСубконто.Регистратор
	|			И ВТ_Документы.Период = ХозрасчетныйСубконто.Период
	|			И (ХозрасчетныйСубконто.Вид = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры))
	|ГДЕ
	|	НЕ ХозрасчетныйСубконто.Значение ЕСТЬ NULL 
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДоговорКонтрагента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДоговорыПоДокументам.Период КАК Период,
	|	ВТ_ДоговорыПоДокументам.Регистратор КАК Регистратор,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ДоговорыКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
	|				ТОГДА ДоговорыКонтрагентов.Владелец
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|		КОНЕЦ) КАК Покупатель,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ДоговорыКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
	|				ТОГДА ДоговорыКонтрагентов.Ссылка
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|		КОНЕЦ) КАК ДоговорСПокупателем,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ДоговорыКонтрагентов.ВидДоговора <> ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
	|				ТОГДА ДоговорыКонтрагентов.Владелец
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|		КОНЕЦ) КАК ДругойКонтрагент,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ДоговорыКонтрагентов.ВидДоговора <> ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
	|				ТОГДА ДоговорыКонтрагентов.Ссылка
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|		КОНЕЦ) КАК ДоговорДругогоКонтрагента,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДоговорыКонтрагентов.Ссылка) КАК КоличествоДоговоров
	|ИЗ
	|	ВТ_ДоговорыПоДокументам КАК ВТ_ДоговорыПоДокументам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ПО ВТ_ДоговорыПоДокументам.ДоговорКонтрагента = ДоговорыКонтрагентов.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ДоговорыПоДокументам.Период,
	|	ВТ_ДоговорыПоДокументам.Регистратор
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ,
	|	Регистратор УБЫВ";

	УстановитьПривилегированныйРежим(Истина);

	РезультатЗапроса = Запрос.Выполнить();

	Если РезультатЗапроса.Пустой() Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = Ложь;
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	ВыборкаПоДокументам = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		Попытка
			
			ЗаполнитьДоговорКонтрагентаПоДокументу(ВыборкаПоДокументам);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			КонецПериодаВыборки = ВыборкаПоДокументам.Период; // Запоминаем дату, с которой будем начинать в следующий раз.
			СсылкаНаПоследнийДокумент = ВыборкаПоДокументам.Регистратор;
			
		Исключение
			// Если не удалось обработать какой-либо документ, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось обработать %1 по причине:
					|%2'", ОбщегоНазначения.КодОсновногоЯзыка()),
				ВыборкаПоДокументам.Регистратор,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));

			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.РегистрыНакопления.КнигаУчетаДоходовИРасходов,
				ВыборкаПоДокументам.Регистратор, 
				ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	// Запоминаем дату, с которой будем начинать в следующий раз.
	Параметры.Вставить("КонецПериодаВыборки", 		КонецПериодаВыборки);
	Параметры.Вставить("СсылкаНаПоследнийДокумент", СсылкаНаПоследнийДокумент);
	
	Если ОбъектовОбработано = 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре РегистрыНакопления.КнигаУчетаДоходовИРасходов.ЗаполнитьДоговорКонтрагентаОтложенно()
				|не удалось обработать некоторые регистраторы (пропущены): %1'"),
				ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация,
			Метаданные.РегистрыНакопления.КнигаУчетаДоходовИРасходов,
			,
			СтрШаблон(НСтр("ru = 'Процедура РегистрыНакопления.КнигаУчетаДоходовИРасходов.ЗаполнитьДоговорКонтрагентаОтложенно()
					|обработала очередную порцию записей регистра КУДиР: %1 документов'", ОбщегоНазначения.КодОсновногоЯзыка()), 
					ОбъектовОбработано));
	КонецЕсли;


КонецПроцедуры

Процедура ЗаполнитьДоговорКонтрагентаПоДокументу(ВыборкаПоДокументам)

	// Заполняем в регистре КнигаУчетаДоходовИРасходов реквизиты Контрагент и Договоров в случаях:
	// 1. Если в бухгалтерских проводках документа встречается только один договор.
	// 2. Для документов РеализацияТоваровУслуг и КорректировкаРеализации при продаже комиссионных товаров/услуг
	// 	  могут встречаться несколько договоров с комитентами и договор с покупателем, заполняем договором с покупателем.
	Контрагент 			= Неопределено;
	ДоговорКонтрагента 	= Неопределено;
	ТипРегистратора 	= ТипЗнч(ВыборкаПоДокументам.Регистратор);
	
	Если ТипРегистратора = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		ИЛИ ТипРегистратора = Тип("ДокументСсылка.КорректировкаРеализации") Тогда

		Контрагент 			= ВыборкаПоДокументам.Покупатель;
		ДоговорКонтрагента 	= ВыборкаПоДокументам.ДоговорСПокупателем;

	ИначеЕсли ВыборкаПоДокументам.КоличествоДоговоров = 1 Тогда

		Если ЗначениеЗаполнено(ВыборкаПоДокументам.Покупатель) Тогда
			Контрагент 			= ВыборкаПоДокументам.Покупатель;
			ДоговорКонтрагента 	= ВыборкаПоДокументам.ДоговорСПокупателем;
		Иначе
			Контрагент 			= ВыборкаПоДокументам.ДругойКонтрагент;
			ДоговорКонтрагента	= ВыборкаПоДокументам.ДоговорДругогоКонтрагента;
		КонецЕсли;

	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Контрагент) ИЛИ НЕ ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		Возврат;
	КонецЕсли;

	НачатьТранзакцию();
	Попытка
		
		// Блокируем объект от изменения другими сеансами.
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.КнигаУчетаДоходовИРасходов.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", ВыборкаПоДокументам.Регистратор);
		Блокировка.Заблокировать();
		
		// Заполним в наборе регистра реквизиты Контрагент и ДоговорКонтрагента, если они еще не были заполнены в другом сеансе.
		НаборЗаписей = РегистрыНакопления.КнигаУчетаДоходовИРасходов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаПоДокументам.Регистратор);
		НаборЗаписей.Прочитать();
		
		Для Каждого Движение Из НаборЗаписей Цикл
			Если НЕ ЗначениеЗаполнено(Движение.ДоговорКонтрагента) Тогда
				Движение.Контрагент 		= Контрагент;
				Движение.ДоговорКонтрагента = ДоговорКонтрагента;
			КонецЕсли;
		КонецЦикла;
		
		Если НаборЗаписей.Модифицированность() Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли