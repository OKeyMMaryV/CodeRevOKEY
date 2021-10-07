﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыСоединения = СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(СтрокаСоединенияИнформационнойБазы());
	СистемнаяИнфо = Новый СистемнаяИнформация;
	
	Если ЗначениеЗаполнено(СистемнаяИнфо.ИнформацияПрограммыПросмотра)
		ИЛИ НЕ ПараметрыСоединения.Свойство("File") Тогда
		// веб-клиент или сервер
		ОткрытьФорму("Обработка.ПереносДанныхИзИнформационныхБаз1СПредприятия77.Форма.ФормаЗагрузкаИзФайла");
	Иначе
		// локальный режим
		ОткрытьФорму("Обработка.ПереносДанныхИзИнформационныхБаз1СПредприятия77.Форма");
	КонецЕсли;
	
КонецПроцедуры
