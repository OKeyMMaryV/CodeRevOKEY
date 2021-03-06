#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли; 
	
	Если ПометкаУдаления <> Ссылка.ПометкаУдаления 
		 И ЗначениеЗаполнено(Алгоритм)  Тогда
		// Синхронизацию задач выполняем только для задач, включенных в процесс, 
		// т.к. в задачах генерируемых процессами предметы тоже могут генериться, 
		// а в задачах созданных вручную можно только привязать существующий предмет.
		ДополнительныеСвойства.Вставить("СинхронизироватьПометку");
		Возврат;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(БизнесПроцесс) И Выполнена = Ложь И Ссылка.Выполнена = Истина Тогда
		ДополнительныеСвойства.Вставить("ОтменаВыполнения");
	КонецЕсли; 
	
	Если ЭтотОбъект.Состояние <> Ссылка.Состояние Тогда
		ДополнительныеСвойства.Вставить("ИзмененоСостояние");
	КонецЕсли; 
	
	Если ДополнительныеСвойства.Свойство("ВыполнениеАвтоматически") Тогда
		 ЭтотОбъект.Выполнена = Истина;
		 ЭтотОбъект.Состояние = Справочники.бит_СтатусыОбъектов.Задача_Выполнена;
		 ЭтотОбъект.СостояниеПредыдущее = Справочники.бит_СтатусыОбъектов.Задача_Создана;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриВыполнении(Отказ)
	
	Если НЕ Отказ Тогда
		// При завершении подчиненного процесса признак Выполнена ставится автоматически
		// в этом случае установим состояние Задача_Выполнена.
		Если ЗначениеЗаполнено(АлгоритмПодчиненный) И Выполнена Тогда
			 Состояние = Справочники.бит_СтатусыОбъектов.Задача_Выполнена;
			 ДатаОкончанияИсполнения = ТекущаяДата();
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
			ДополнительныеСвойства.Вставить("Выполнение");
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		 Возврат;
	КонецЕсли; 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ Отказ Тогда
		
		// Выполнение старта подчиненного процесса
		Если ЭтоВедущаяЗадача() Тогда
			
			ПроцессПодчиненный = НайтиПодчиненныйПроцесс(Неопределено);
			
			Если НЕ ЗначениеЗаполнено(ПроцессПодчиненный) Тогда
				
				Задачи.бит_уп_Задача.СоздатьПодчиненныйБизнесПроцесс(Ссылка, Истина, "Ошибки");
				
			КонецЕсли; 
			
		КонецЕсли; 
		
		Если ДополнительныеСвойства.Свойство("ИзмененоСостояние") Тогда
			
			СохранитьИсторию();
			ВыполнитьРегистрациюСобытийДляОповещений(Отказ);
			
			ДополнительныеСвойства.Удалить("ИзмененоСостояние");
			
		КонецЕсли; 
		
		// Синхронизация пометки удаления у предмета и задачи, а также у подчиненного процесса.
		Если ДополнительныеСвойства.Свойство("СинхронизироватьПометку") Тогда
			
			Если ЗначениеЗаполнено(Предмет) Тогда
				
				// Изменение кода. Начало. 20.04.2018{{
				Попытка
					Если Предмет.Проведен Тогда
					
						ТекстСообщения = НСтр("ru = 'Предмет задачи " +Предмет+ " проведен. 
												|Для удаление задачи необходимо отменить проведение документа.'");
						бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
						Возврат;
					КонецЕсли; 
				Исключение
				КонецПопытки;
				// Изменение кода. Конец. 20.04.2018}}
				
				бит_ОбщегоНазначения.ИзменитьПометкуНаУдалениеУОбъекта(Предмет
																		,ПометкаУдаления
																		,
																		,"Ошибки"
																		,Новый Структура("ОшибкуПодробно"));
				
				
			КонецЕсли; 
			
			ПроцессПодчиненный = НайтиПодчиненныйПроцесс(ПроцессПодчиненный);
			Если ЗначениеЗаполнено(ПроцессПодчиненный) Тогда
				
				бит_ОбщегоНазначения.ИзменитьПометкуНаУдалениеУОбъекта(ПроцессПодчиненный
																		,ПометкаУдаления
																		,
																		,"Ошибки"
																		,Новый Структура("ОшибкуПодробно"));
			
			КонецЕсли; 
			
			ДополнительныеСвойства.Удалить("СинхронизироватьПометку");
			
		КонецЕсли; // Синхронизация пометки
		
		// Остановка подчиненного процесса
		Если ЭтоВедущаяЗадача() И ДополнительныеСвойства.Свойство("Остановить") Тогда
			
			ПроцессПодчиненный = НайтиПодчиненныйПроцесс(ПроцессПодчиненный);
			
			Если ЗначениеЗаполнено(ПроцессПодчиненный) Тогда
			
				БизнесПроцессы.бит_уп_Процесс.ОстановитьПроцесс(ПроцессПодчиненный);
			
			КонецЕсли; 
			
			ДополнительныеСвойства.Удалить("Остановить");
		
		КонецЕсли; 
		
		// Продолжение подчиненного процесса
		Если ЭтоВедущаяЗадача() И ДополнительныеСвойства.Свойство("Продолжить") Тогда
			
			ПроцессПодчиненный = НайтиПодчиненныйПроцесс(ПроцессПодчиненный);
			
			Если ЗначениеЗаполнено(ПроцессПодчиненный) Тогда
			
				БизнесПроцессы.бит_уп_Процесс.ПродолжитьПроцесс(ПроцессПодчиненный);
			
			КонецЕсли; 
			
			ДополнительныеСвойства.Свойство("Продолжить");
		
		КонецЕсли; 
		
		// Создание задач процесса
		Если ДополнительныеСвойства.Свойство("Выполнение") Тогда
			
			// Событие бизнес-процесса "ПередСозданиемЗадач" возникает, только после выполнения последней 
			// задачи в точке маршрута бизнес-процесса. А точка маршрута типа ТочкаДействия в бизнес-процессе 
			// бит_уп_Процесс только одна. Поэтому если в процессе есть невыполненные задачи, необходимо выполнить 
			// создание последующих задач процесса из модуля задачи.
			Исключения = Новый Массив;
			Исключения.Добавить(Ссылка);
			флЕстьНевыполненные = БизнесПроцессы.бит_уп_Процесс.ЕстьНевыполненныеЗадачи(БизнесПроцесс, Исключения);
			
			Если флЕстьНевыполненные Тогда
				
				ФормируемыеЗадачи = Новый Массив;
				БизнесПроцессы.бит_уп_Процесс.СоздатьЗадачиПроцесса(БизнесПроцесс, ФормируемыеЗадачи);
				
				Для каждого ЗадачаОбъект Из ФормируемыеЗадачи Цикл
					бит_ОбщегоНазначения.ЗаписатьЗадачу(ЗадачаОбъект,"Ошибки");
				КонецЦикла; 
			КонецЕсли; 
			
			// При повторном выполнении нижестоящие задачи не создаются заново, а продолжается их выполнение.
			НижестоящиеЗадачи = Задачи.бит_уп_Задача.НижестоящиеЗадачи(Ссылка, "Остановленные");
			Задачи.бит_уп_Задача.ПродолжитьВыполнение(НижестоящиеЗадачи, Истина);			
			
			ДополнительныеСвойства.Удалить("Выполнение");
			
		КонецЕсли; 
		
		Если ДополнительныеСвойства.Свойство("ВыполнениеАвтоматически") Тогда
			
			ФормируемыеЗадачи = Новый Массив;
			БизнесПроцессы.бит_уп_Процесс.СоздатьЗадачиПроцесса(БизнесПроцесс, ФормируемыеЗадачи);
			
			Для каждого ЗадачаОбъект Из ФормируемыеЗадачи Цикл
				Если ЗадачаОбъект.ТочкаАлгоритма = ЭтотОбъект.ТочкаАлгоритма Тогда
					 Продолжить;
				КонецЕсли; 
				бит_ОбщегоНазначения.ЗаписатьЗадачу(ЗадачаОбъект,"Ошибки");
			КонецЦикла; 
		КонецЕсли; 
		
		Если ДополнительныеСвойства.Свойство("ОтменаВыполнения") Тогда
			
			// При отмене выполнения нижестоящие задачи переводятся в состояние "Остановлена". 			
			НижестоящиеЗадачи = Задачи.бит_уп_Задача.НижестоящиеЗадачи(Ссылка, "Активные");
			Задачи.бит_уп_Задача.Остановить(НижестоящиеЗадачи, Истина);
			ДополнительныеСвойства.Удалить("ОтменаВыполнения");
		
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(БизнесПроцесс) 
			  И ДополнительныеСвойства.Свойство("ЭтоНовый") 
			  И ДополнительныеСвойства.ЭтоНовый = Истина Тогда
			
			// Выполнение автоматических действий фоновым заданием.
			ПараметрыЗадания = Новый Массив;
			ПараметрыЗадания.Добавить(Ссылка);
			
			НаименованиеЗадания = Строка(БизнесПроцесс.УникальныйИдентификатор());
			
			// 01.12.17 ВАЖНО! Если при выполнении автодействия (при записи) произодет ошибка, то новая задача записана не будет.
			// Вызов выполнения перенс в раздел "Выполнение". BF-1617, BF-530.
			// 14.02.2018 ВАЖНО! Проблема с заполнением задач при старте процесса. BF-1917
			Если ЗначениеЗаполнено(Предмет) Тогда
				//ФоновыеЗадания.Выполнить("бит_уп_Сервер.ВыполнитьАвтоматическиеДействия", ПараметрыЗадания, ,НаименованиеЗадания);
				бит_уп_Сервер.ВыполнитьАвтоматическиеДействия(Ссылка);
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

 #КонецОбласти
 
#Область СлужебныйПрограммныйИнтерфейс

// Функция определяет является ли данная задача ведущей или нет.
// 
// Возвращаемое значение:
//  флВедущая - Булево.
// 
Функция ЭтоВедущаяЗадача() Экспорт

	флВедущая = Задачи.бит_уп_Задача.ЭтоВедущаяЗадача(ЭтотОбъект);

	Возврат флВедущая;
	
КонецФункции // ЭтоВедущаяЗадача()

// Функция выполняет поиск подчиненного процесса для ведущей задачи.
// 
// Параметры:
//  ПроцессПодчиненный - БизнесПроцессСсылка.бит_уп_Процессы.
// 
// Возвращаемое значение:
//  РезПроцесс - Строка.
// 
Функция НайтиПодчиненныйПроцесс(ПроцессПодчиненный) Экспорт
	
	Если ЗначениеЗаполнено(ПроцессПодчиненный) Тогда
		РезПроцесс = ПроцессПодчиненный;
	Иначе	
		РезПроцесс = Задачи.бит_уп_Задача.НайтиПодчиненныйПроцесс(Ссылка);
	КонецЕсли; 
	
	Возврат РезПроцесс;
	
КонецФункции // НайтиПодчиненныйПроцесс()

#Область ДействияНадЗадачей

// Процедура принимает задачу к исполнению.
// 
Процедура ПринятьКИсполнению()  Экспорт
	
	СостояниеПредыдущее = Состояние;
	
	ДатаНачалаИсполнения = ТекущаяДата();	
	Состояние   = Справочники.бит_СтатусыОбъектов.Задача_Принята;
	
	ТекПользователь = Пользователи.ТекущийПользователь();
	Если НЕ ЗначениеЗаполнено(Исполнитель) Тогда
		Исполнитель = ТекПользователь;
	КонецЕсли; 
	
	Если ТекПользователь<>Исполнитель Тогда
		Исполнитель = ТекПользователь;
	КонецЕсли; 
	
КонецПроцедуры // ПринятьКИсполнению()

// Процедура отмечает выполнение задачи.
// 
Процедура ОтметитьВыполнение(Интерактивно = Ложь, ЭтоПеренаправление = Ложь) Экспорт
	
	СостояниеПредыдущее = Состояние;
	
	Если Состояние = Справочники.бит_СтатусыОбъектов.Задача_Создана Тогда
		ПринятьКИсполнению();
	КонецЕсли; 
	
	Если ЭтоПеренаправление Тогда
		
		ТочкаАлгоритма = Справочники.бит_уп_ТочкиАлгоритмов.ПустаяСсылка();
		Алгоритм       = Справочники.бит_уп_Алгоритмы.ПустаяСсылка();
		БизнесПроцесс  = БизнесПроцессы.бит_уп_Процесс.ПустаяСсылка();
		ТочкаМаршрута  = Неопределено;
		
	КонецЕсли; 
	
	ДатаОкончанияИсполнения = ТекущаяДата();
	Состояние = Справочники.бит_СтатусыОбъектов.Задача_Выполнена;	
	
	Если Интерактивно Тогда
		ВыполнитьЗадачуИнтерактивно();
	Иначе
		ВыполнитьЗадачу();
	КонецЕсли; 
	
КонецПроцедуры // ОтметитьВыполнение()

// Процедура отменяет задачу.
// 
Процедура ОтменитьЗадачу(ЭтоПеренаправление = Ложь) Экспорт
	
	СостояниеПредыдущее = Состояние;
	
	Состояние = Справочники.бит_СтатусыОбъектов.Задача_Отменена;		
	ВыполнитьЗадачу();	
	
КонецПроцедуры // ОтменитьЗадачу() 

// Процедура возобновляет задачу. 
// 
Процедура ВозобновитьЗадачу() Экспорт
	
	СостояниеПредыдущее = Состояние;
	
	Выполнена = Ложь;
	Состояние = Справочники.бит_СтатусыОбъектов.Задача_Создана;
	ДатаНачалаИсполнения    = Дата('00010101');
	ДатаОкончанияИсполнения = Дата('00010101');
	
КонецПроцедуры // ВозобновитьЗадачу() 

// Процедура выполняет остановку задачи.
// 
Процедура Остановить()  Экспорт
	
	СостояниеПредыдущее = Состояние;
	Состояние = Справочники.бит_СтатусыОбъектов.Задача_Остановлена;	
	
	ДополнительныеСвойства.Вставить("Остановить");
	
КонецПроцедуры // ОстановитьЗадачу()

// Процедура возобновляет выполнение задачи после остановки.
// 
Процедура ПродолжитьВыполнение() Экспорт

	Если НЕ СостояниеПредыдущее = Справочники.бит_СтатусыОбъектов.Задача_Остановлена Тогда
		Состояние = СостояниеПредыдущее;
	Иначе	
		Состояние = Справочники.бит_СтатусыОбъектов.Задача_Создана;
	КонецЕсли; 
	
    СостояниеПредыдущее = Справочники.бит_СтатусыОбъектов.Задача_Остановлена;
	
	ДополнительныеСвойства.Вставить("Продолжить");
	
КонецПроцедуры // ПродолжитьВыполнение()

// Процедура возвращает задачу в предыдущее состояние.
// В текущей реализации используется для возврата из состояния Выполнено.
// 
Процедура Вернуться() Экспорт
	
	Выполнена = Ложь;
	Состояние               = СостояниеПредыдущее;
	ДатаОкончанияИсполнения = Дата('00010101');	
	
КонецПроцедуры // Вернуться() 

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура сохраняет историю изменения состояния задачи.
// 
Процедура СохранитьИсторию()
	
	// Сохраним историю изменения статуса
	МенеджерЗаписи = РегистрыСведений.бит_ИсторияИзмененияСтатусовОбъектов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Объект       = Ссылка;
	МенеджерЗаписи.Период       = ТекущаяДата();
	МенеджерЗаписи.ВидСтатуса   = Перечисления.бит_ВидыСтатусовОбъектов.Статус;
	МенеджерЗаписи.Пользователь = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь");
	МенеджерЗаписи.Статус       = Состояние;
	Попытка
		
		МенеджерЗаписи.Записать();
		
	Исключение
		
		ТекстСообщения = НСтр("ru = 'Не удалось сохранить историю изменения статуса объекта ""%Объект%""!'")
						+" "
						+ОписаниеОшибки();
		СтрЗамена      = Новый Структура("Объект",Строка(ЭтотОбъект));
		ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ЗаполнитьПараметрыСтроки(ТекстСообщения,СтрЗамена);
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);		
		
	КонецПопытки;
	
КонецПроцедуры // СохранитьИсторию()

// Процедура выполняет регистрацию событий для оповещений.
// 
// Параметры:
// 	Отказ - булево - отказ от записи объекта.
// 
Процедура ВыполнитьРегистрациюСобытийДляОповещений(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("бит_ИспользоватьМеханизмОповещений") Тогда
		Возврат;	
	КонецЕсли;
	
	ТаблицаОповещений = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_фн_АктивныеОповещения");
	
	// Обработаем события
	Если НЕ ТаблицаОповещений = Неопределено И НЕ ЭтотОбъект.ДополнительныеСвойства.Свойство("бит_ОтключитьРегистрациюОповещений") Тогда
		
		// Определим объект системы по метаданным
		ОбъектСистемы = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(ЭтотОбъект.Метаданные());
		
		ВидСобытия = Перечисления.бит_фн_ВидыСобытийОповещений.ИзмененоСостояниеЗадачи;
		
		// Получим оповещения данного вида для данного объекта.
		СтрОтбор = Новый Структура("ВидСобытия,ОбъектСистемы"
									,ВидСобытия
									,ОбъектСистемы);
									
		МассивОповещений = ТаблицаОповещений.НайтиСтроки(СтрОтбор);							
		
		Для Каждого СтрокаОповещения Из МассивОповещений Цикл
			
			// Проверим "быстрые" условия
			флАлгоритмПроцессаСоответствует = Ложь;
			флТочкаАлгоритмаСоответствует	= Ложь;
			флСостояниеСоответствует		= Ложь;
			
			// Проверим алгоритм
			Если НЕ ЗначениеЗаполнено(СтрокаОповещения.АлгоритмПроцесса) Тогда
				
				флАлгоритмПроцессаСоответствует = Истина;
				
			ИначеЕсли СтрокаОповещения.АлгоритмПроцесса = ЭтотОбъект.Алгоритм Тогда
				
				флАлгоритмПроцессаСоответствует = Истина;
				
			КонецЕсли;
			
			// Проверим точку алгоритма
			Если НЕ ЗначениеЗаполнено(СтрокаОповещения.ТочкаАлгоритма) Тогда
				
				флТочкаАлгоритмаСоответствует = Истина;
				
			ИначеЕсли СтрокаОповещения.ТочкаАлгоритма = ЭтотОбъект.ТочкаАлгоритма Тогда
				
				флТочкаАлгоритмаСоответствует = Истина;
				
			КонецЕсли;
			
			// Проверим состояние
			Если НЕ ЗначениеЗаполнено(СтрокаОповещения.Статус) Тогда
				
				флСостояниеСоответствует = Истина;
				
			ИначеЕсли СтрокаОповещения.Статус = ЭтотОбъект.Состояние Тогда
				
				флСостояниеСоответствует = Истина;
				
			КонецЕсли;
			
			флСоответствует = флАлгоритмПроцессаСоответствует 
							И флСостояниеСоответствует
							И флТочкаАлгоритмаСоответствует;
			
			// Если задано пользовательское условие, проверим его.
			Если флСоответствует И ЗначениеЗаполнено(СтрокаОповещения.ПользовательскоеУсловие) Тогда
				
				СтруктураКонтекст = Новый Структура("ТекущийОбъект",ЭтотОбъект);
				
				флСоответствует = бит_уп_Сервер.ПроверитьПользовательскоеУсловие(СтрокаОповещения.ПользовательскоеУсловие
				                                                                 ,СтруктураКонтекст);
				
			КонецЕсли;
																			 
			Если флСоответствует Тогда
				
				ЗарегистрироватьСобытиеДляОповещений(ВидСобытия,СтрокаОповещения.Оповещение,ЭтотОбъект);
				
			КонецЕсли;  // Событие соответствует отборам
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура регистрирует событие в регистре сведений бит_фн_РегистрацияСобытийОповещений 
// для последующей обработки и создания оповещений.
// 
// Параметры:
//  ВидСобытия  - ПеречислениеСсылка.бит_фн_ВидыСобытийОповещений
//  Оповещение  - СправочникСсылка.бит_фн_Оповещения
//  ИсточникСсылка  - СправочникСсылка, ДокументСсылка.
// 
Процедура ЗарегистрироватьСобытиеДляОповещений(ВидСобытия,Оповещение,ПроцессОбъект)
	
	бит_фн_ОповещенияСервер.ЗарегистрироватьСобытиеДляОповещений(ВидСобытия, Оповещение, ПроцессОбъект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
