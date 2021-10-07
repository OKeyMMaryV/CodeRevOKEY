﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мРежимОбновленияВиз Экспорт; // Хранит режим обновления перечня виз.

Перем мБылПроведен; // Служит для передачи признака проведения между обработчиками.

Перем мРежимЗаписи; // Служит для передачи режима записи между обработчиками.

Перем мТекущийСтатус Экспорт; // Хранит текущий статус.

Перем мДатаИзмененияСтатуса Экспорт; // Хранит дату изменения статуса.

Перем мАлгоритмИзмененияСтатуса Экспорт; // Хранит текущий алгоритм изменения статуса.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ВидИнформационнойБазы = Справочники.бит_мпд_ВидыИнформационныхБаз.ТекущаяИнформационнаяБаза;
	
	Если ЭтоНовый() Тогда
		
		// Заполнение шапки
		бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект
		                                               , бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
													   , Неопределено);
													   
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	мРежимЗаписи = РежимЗаписи;
	мБылПроведен = Проведен;	
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	
	
	Если НЕ Отказ Тогда
		
		Если НЕ мРежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			
			СтатусНач = мТекущийСтатус;			
			УстановитьСтатус(мРежимЗаписи);
			
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры // ПриЗаписи()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	

	
	Если НЕ Отказ Тогда
		
		// Заполним перечень виз
		Если мРежимОбновленияВиз = Перечисления.бит_РежимыОбновленияПеречняВиз.ОбновлятьПриПерепроведении ИЛИ НЕ мБылПроведен Тогда
			
			СтруктураПараметров = Новый Структура;
			бит_Визирование.ОбновитьПереченьВиз(Ссылка,Дата,СтруктураПараметров);
			
		КонецЕсли; 		
		
		// Установим статус.
		УстановитьСтатус(РежимЗаписиДокумента.Проведение);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если НЕ Отказ Тогда
		
		// Очистим визы.
		бит_Визирование.ОчиститьВсеВизыБезусловно(ЭтотОбъект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Установка настроек обязательности реквизитов
	СтатусДляПоискаНастроек = ?(ЗначениеЗаполнено(мТекущийСтатус), мТекущийСтатус, Справочники.бит_СтатусыОбъектов.ЗаявкаНаУдаление_Черновик);
	бит_ОбщегоНазначения.УстановитьНастройкиОбязательностиРеквизитов(ЭтотОбъект, ПроверяемыеРеквизиты, СтатусДляПоискаНастроек);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура устанавливает статус документа.
// 
// Параметры:
//  РежимЗаписи - РежимЗаписиДокумента.
// 
Процедура УстановитьСтатус(вхРежимЗаписи = Неопределено) Экспорт
	
	СтрАлгоритмы              = бит_уп_Сервер.ПолучитьАлгоритмыОбъектаСистемы(ЭтотОбъект,Перечисления.бит_уп_ВидыАлгоритмов.ИзменениеСтатусовОбъектов);
	мАлгоритмИзмененияСтатуса = СтрАлгоритмы.ИзменениеСтатусовОбъектов;
	
	
	Если НЕ ЗначениеЗаполнено(мАлгоритмИзмененияСтатуса) Тогда
	
		Если вхРежимЗаписи = Неопределено Тогда
			 РежимЗаписи = РежимЗаписиДокумента.Запись;
		Иначе	
			 РежимЗаписи = вхРежимЗаписи;
		КонецЕсли;
		 
		// Вычислим переменные, необходимые для установки статуса.
	    ВсеВизыПолучены = бит_Визирование.ВизыПолучены(Ссылка);
		ЕстьОтклонено   = бит_Визирование.ПринятоРешение(Ссылка, , Справочники.бит_ВидыРешенийСогласования.Отклонено);
		
		
		// Определим статус.		
	    Статус = ОпределитьСтатус(мТекущийСтатус, ВсеВизыПолучены, ЕстьОтклонено, РежимЗаписи);
		
		// Если статус изменился - запишем его
		Если мТекущийСтатус <> Статус Тогда
			
			ДатаИзмененияСтатуса = ТекущаяДата();
			
			ДействиеВыполнено = бит_Визирование.УстановитьСтатусОбъекта(Ссылка
																		, Перечисления.бит_ВидыСтатусовОбъектов.Статус
																		, Статус
																		, мТекущийСтатус
																		, бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
																		, ДатаИзмененияСтатуса);
			
			Если ДействиеВыполнено Тогда
				мТекущийСтатус 		  = Статус;
				мДатаИзмененияСтатуса = ДатаИзмененияСтатуса;
			КонецЕсли; 	
			
		КонецЕсли;
	
	Иначе	
		
		// Выполнение установки статуса согласно алгоритма изменения статусов.
		КомментироватьВыполнение = бит_УправлениеПользователямиСервер.ПолучитьЗначениеПоУмолчанию("КомментироватьХодВыполненияАлгоритмовПроцессов",
								бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"));
			
        РежимСообщений = ?(КомментироватьВыполнение, "Все", "Ошибки");			
			
		СтруктураКонтекст = Новый Структура;
		СтруктураКонтекст.Вставить("ТекущийОбъект", ЭтотОбъект);
		
		бит_уп_Сервер.ВыполнитьАлгоритм(мАлгоритмИзмененияСтатуса,СтруктураКонтекст,РежимСообщений);
		
	КонецЕсли;	
	
КонецПроцедуры // УстановитьСтатус()

// Функция реализует алгоритм определения статуса объекта по-умолчанию.
// 
Функция ОпределитьСтатус(НачальныйСтатус, ВсеВизыПолучены, ЕстьОтклонено, вхРежимЗаписи) Экспорт
	
	РезСтатус = НачальныйСтатус;
	
	Если НачальныйСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаУдаление_Исполнена Тогда
		
		// Если заявка исполнена - статус уже не изменяется.
		
	Иначе	
		
		// Алгоритм изменения статусов для обычного режима.
		Если вхРежимЗаписи = РежимЗаписиДокумента.Проведение 
			ИЛИ (вхРежимЗаписи = РежимЗаписиДокумента.Запись И ЭтотОбъект.Проведен) Тогда
			РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаУдаление_Рабочая;
		Иначе
			РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаУдаление_Черновик;
		КонецЕсли; 
		
		Если РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаУдаление_Рабочая 
			ИЛИ РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаУдаление_Утверждена
			ИЛИ РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаУдаление_Отклонена Тогда
			
			Если ЕстьОтклонено Тогда
				
				РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаУдаление_Отклонена;
				
			Иначе	
				
				Если ВсеВизыПолучены Тогда
					РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаУдаление_Утверждена;
				Иначе	
					РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаУдаление_Рабочая;
				КонецЕсли; 
				
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	Возврат РезСтатус;
	
КонецФункции // ОпределитьСтатус()

// Процедура выполняет заявку на удаление - помечает предмет на удаление. 
// В случае успешного выполнения устанавливается статус Исполнена. 
// 
Процедура ИсполнитьЗаявку() Экспорт
	
	флВыполнено = Ложь;
	
	Если ЗначениеЗаполнено(ЭтотОбъект.Предмет) Тогда
		
		// Установка пометки у объекта хранения
		ПредметОбъект = ЭтотОбъект.Предмет.ПолучитьОбъект();
		ПредметОбъект.ДополнительныеСвойства.Вставить("бит_мдм_РазрешеноИзменение", Истина);
		
		Попытка
		
			ПредметОбъект.УстановитьПометкуУдаления(Истина, Истина);
			флВыполнено = Истина;
		
		Исключение
			
			ТекстСообщения =  НСтр("ru = 'Не удалось пометить на удаление элемент ""%1%""! По причине: %2%.'");
			ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ЭтотОбъект.Предмет, ОписаниеОшибки());
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			
		КонецПопытки;
		
	КонецЕсли; 
	
	Если флВыполнено Тогда
		
		Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаУдаление_Исполнена;
		ДатаИзмененияСтатуса = ТекущаяДата();
		
		ДействиеВыполнено = бит_Визирование.УстановитьСтатусОбъекта(ЭтотОбъект.Ссылка
																	, Перечисления.бит_ВидыСтатусовОбъектов.Статус
																	, Статус
																	, мТекущийСтатус
																	, бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
																	, ДатаИзмененияСтатуса);
		
		Если ДействиеВыполнено Тогда
			мТекущийСтатус 		  = Статус;
			мДатаИзмененияСтатуса = ДатаИзмененияСтатуса;
		КонецЕсли; 	
		
	КонецЕсли; 

КонецПроцедуры // ИсполнитьЗаявку()

#КонецОбласти 

#Область Инициализация

мРежимОбновленияВиз             = Константы.бит_РежимОбновленияПеречняВиз.Получить();

// Получаем статус и дату изменения статуса для документа.
РезСтруктура = бит_Визирование.ПолучитьСтатусОбъекта(Ссылка);

мТекущийСтатус 		  = ?(ЗначениеЗаполнено(РезСтруктура.Статус), РезСтруктура.Статус, Справочники.бит_СтатусыОбъектов.ПустаяСсылка());
мДатаИзмененияСтатуса = РезСтруктура.Дата;

#КонецОбласти

#КонецЕсли
